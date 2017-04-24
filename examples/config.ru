require 'bundler'
require 'rack/contrib'
require 'rack/token_auth'
require 'is_it_done_yet'
Bundler.require

<<<<<<< HEAD
=======
# Shared secret authentication
>>>>>>> bd110d4... EM: adding heartbeat to example setup
use Rack::TokenAuth do |token, _options, _env|
  token == ENV['IIDY_TOKEN']
end

# Heartbeat endpoint
use Rack::Builder.new do
  map '/health_check' do
    run ->(_env) { "success" }
  end
end

run IsItDoneYet.build_app
