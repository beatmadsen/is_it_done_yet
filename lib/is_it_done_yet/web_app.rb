require 'is_it_done_yet/version'
require 'sinatra'
require 'concurrent'
require 'json'
require 'time'
require 'rack/contrib'

module IsItDoneYet
  class WebApp < ::Sinatra::Base
    UNKNOWN_NODE = { errors: ['Unknown Node'] }.to_json
    ALREADY_EXISTS = { errors: ['Node already exists'] }.to_json
    UNKNOWN_BUILD = { errors: ['Unknown Build'] }.to_json
    NO_BUILD_STATE = { errors: ['You forgot build state'] }.to_json
    TTL_SECONDS = 24 * 60 * 60

    configure do
      set :state, ::Concurrent::Map.new
    end

    helpers do
      private

      def key(build_id, node_id)
        [build_id, node_id].freeze
      end

      def house_keeping
        expired_keys =
          settings.state.each_pair.with_object([]) do |(key, (_b, time)), acc|
            acc << key if time < Time.now - TTL_SECONDS
          end

        expired_keys.each { |key| settings.state.delete(key) }
      end

      def store(key, value)
        settings.state[key] = [value, Time.now]
      end

      def retrieve(key)
        build_state, _t = settings.state[key]
        build_state
      end

      def retrieve_all(build_id)
        settings.state
                .each_pair
                .select { |((b, _n), _v)| build_id == b }
                .map { |((_b, node_id), (build_state, _t))| [node_id, build_state] }
                .to_h
      end

      def clear_nodes(build_id)
        state = settings.state
        keys_for_build = state.keys.select { |(b, _n)| b == build_id }
        keys_for_build.each { |key| state.delete(key) }
      end
    end

    before do
      house_keeping

      content_type :json
    end

    get '/builds/:build_id/nodes/:node_id' do
      build_id, node_id = params.values_at('build_id', 'node_id')
      k = key(build_id, node_id)

      build_state = retrieve(k)

      halt 404, UNKNOWN_NODE unless build_state

      { build_state: build_state }.to_json
    end

    get '/builds/:build_id' do
      build_id = params['build_id']

      build_states = retrieve_all(build_id)

      halt 404, UNKNOWN_BUILD if build_states.to_a.empty?

      { build_states: build_states }.to_json
    end

    delete '/builds/:build_id' do
      build_id = params['build_id']

      clear_nodes(build_id)

      204
    end

    post '/builds/:build_id/nodes/:node_id' do
      build_state = params['build_state']
      halt 400, NO_BUILD_STATE unless build_state

      build_id, node_id = params.values_at('build_id', 'node_id')
      k = key(build_id, node_id)
      halt 409, ALREADY_EXISTS if retrieve(k)

      store(k, build_state)

      201
    end
  end
end
