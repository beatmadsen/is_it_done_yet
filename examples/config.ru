require 'bundler'
require 'rack/contrib'
require 'rack/token_auth'
require 'is_it_done_yet'
Bundler.require

use Rack::TokenAuth do |token, _options, _env|
  token == ENV['IIDY_TOKEN']
end

run IsItDoneYet.build_app
