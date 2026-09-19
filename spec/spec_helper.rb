# frozen_string_literal: true

require 'bundler/setup'

# Sinatra restricts which Host headers it will answer in the development
# environment, and rack-test sends example.org. Set before the app is loaded,
# because Sinatra reads it when the class is defined.
ENV['RACK_ENV'] ||= 'test'

require 'is_it_done_yet'
require 'rspec'
require 'rack/test'
require 'json'
require 'knapsack'
require 'byebug'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Knapsack::Adapters::RSpecAdapter.bind

def parse(json_text)
  JSON.parse(json_text)
end
