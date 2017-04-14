require 'is_it_done_yet/version'
require 'sinatra'
require 'concurrent'
require 'json'


module IsItDoneYet


  class WebApp < ::Sinatra::Base
    UNKNOWN_NODE = { errors: ['Unknown Node'] }.to_json
    NO_BUILD_STATE = { errors: ['You forgot build state'] }.to_json

    configure do
      set :state, ::Concurrent::Map.new
    end

    helpers do
      private

      def key(project_id, node_id)
        "#{project_id}|#{node_id}"
      end
    end

    before do
      content_type :json
    end

    get '/projects/:project_id/nodes/:node_id' do
      project_id, node_id = params.values_at('project_id', 'node_id')
      k = key(project_id, node_id)
      build_state = settings.state[k]

      halt 404, UNKNOWN_NODE unless build_state

      content_type :json
      { build_state: build_state }.to_json
    end

    post '/projects/:project_id/nodes/:node_id' do
      build_state = params['build_state']
      halt 400, NO_BUILD_STATE unless build_state

      project_id, node_id = params.values_at('project_id', 'node_id')
      k = key(project_id, node_id)

      settings.state[k] = build_state

      200
    end
  end
end
