require 'is_it_done_yet/version'
require 'sinatra'
require 'concurrent'

module IsItDoneYet
  class WebApp < ::Sinatra::Base
    configure do
      set :state, ::Concurrent::Map.new
    end

    get '/' do
      settings.state.each_pair.to_h.inspect.to_s
    end

    post '/' do
      params.each do |(key, value)|
        settings.state[key] = value
      end
      ''
    end
  end
end
