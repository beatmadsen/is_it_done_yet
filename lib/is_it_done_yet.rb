require 'is_it_done_yet/version'
require 'sinatra'
require 'concurrent'
require 'json'
require 'time'

module IsItDoneYet
  class WebApp < ::Sinatra::Base
    UNKNOWN_NODE = { errors: ['Unknown Node'] }.to_json
    NO_BUILD_STATE = { errors: ['You forgot build state'] }.to_json
    TTL_SECONDS = 24 * 60 * 60

    configure do
      set :state, ::Concurrent::Map.new
    end

    helpers do
      private

      def key(project_id, node_id)
        "#{project_id}|#{node_id}"
      end

      def house_keeping
        expired_keys = settings.state
          .each_pair.with_object([]) do |(key, (_b, time)), acc|
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
    end

    before do
      house_keeping

      content_type :json
    end

    get '/projects/:project_id/nodes/:node_id' do
      project_id, node_id = params.values_at('project_id', 'node_id')
      k = key(project_id, node_id)

      build_state = retrieve(k)

      halt 404, UNKNOWN_NODE unless build_state

      content_type :json
      { build_state: build_state }.to_json
    end

    post '/projects/:project_id/nodes/:node_id' do
      build_state = params['build_state']
      halt 400, NO_BUILD_STATE unless build_state

      project_id, node_id = params.values_at('project_id', 'node_id')
      k = key(project_id, node_id)
      store(k, build_state)

      200
    end
  end

  def self.build_app
    Rack::Builder.app do
      use Rack::PostBodyContentTypeParser
      run WebApp
    end
  end
end
