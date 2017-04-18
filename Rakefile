require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'knapsack'


RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Knapsack.load_tasks if defined?(Knapsack)
