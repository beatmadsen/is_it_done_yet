require 'rubygems'
require 'bundler'

Bundler.require

require './lib/is_it_done_yet'

require 'rack/contrib'
require 'rack/token_auth'

use Rack::PostBodyContentTypeParser

use Rack::TokenAuth do |token, options, env|
  token == "my secret token"
end


run IsItDoneYet::WebApp
