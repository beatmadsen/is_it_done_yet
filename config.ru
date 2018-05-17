# frozen_string_literal: true

require 'bundler'
require 'rack/contrib'
require 'rack/token_auth'
require 'is_it_done_yet'
Bundler.require

# Shared secret authentication
use Rack::TokenAuth do |token, _options, _env|
  token == ENV['IIDY_TOKEN']
end

# Heartbeat endpoint
map '/health_check' do
  run ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['success']] }
end

run IsItDoneYet.build_app
