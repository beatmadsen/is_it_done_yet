# frozen_string_literal: true

require 'is_it_done_yet/version'
require 'is_it_done_yet/web_app'
require 'rack/contrib'
require 'rack'

module IsItDoneYet
  def self.build_app
    Rack::Builder.app do
      use Rack::PostBodyContentTypeParser
      run WebApp
    end
  end
end
