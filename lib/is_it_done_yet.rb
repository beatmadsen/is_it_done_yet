# frozen_string_literal: true

require 'is_it_done_yet/version'
require 'is_it_done_yet/web_app'
require 'json'
require 'rack/contrib'
require 'rack'

module IsItDoneYet
  # rack-contrib's own parser calls JSON.parse with create_additions, which json
  # 3 removed, so every JSON request body fails there on Ruby 4. The middleware
  # takes a parser block, so supply one that does not use the removed keyword.
  PARSE_JSON_BODY = ->(body) { JSON.parse(body) }

  def self.build_app
    Rack::Builder.app do
      use Rack::JSONBodyParser, &PARSE_JSON_BODY
      run WebApp
    end
  end
end
