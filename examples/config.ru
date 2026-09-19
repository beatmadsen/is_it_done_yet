# frozen_string_literal: true

require 'bundler'
require 'rack/contrib'
require 'rack/token_auth'
require 'is_it_done_yet'
Bundler.require

# Shared secret authentication. The gem does not depend on rack-token_auth, so
# add it, and a server such as puma, to your own Gemfile. Which middleware and
# which server to run are yours to choose.
use Rack::TokenAuth do |token, _options, _env|
  token == ENV['IIDY_TOKEN']
end

# Heartbeat endpoint
map '/health_check' do
  run ->(_env) { [200, { 'content-type' => 'text/plain' }, ['success']] }
end

run IsItDoneYet.build_app
