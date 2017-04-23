# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'is_it_done_yet/version'

Gem::Specification.new do |spec|
  spec.name          = 'is_it_done_yet'
  spec.version       = IsItDoneYet::VERSION
  spec.authors       = ['Erik Madsen']
  spec.email         = ['beatmadsen@gmail.com']

  spec.summary       = 'Tracks statuses of CI build nodes'
  spec.description   = 'In case you need to carry out build steps in one of the nodes of your CI project after the other nodes finish, e.g. deploying, then you need a way of ascertaining the status of the other nodes. This is what is_it_done_yet is for.'
  spec.homepage      = 'http://www.github.com/beatmadsen/is_it_done_yet'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/}) ||
      f.match(/knapsack/)
  end
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  # Always
  spec.add_dependency 'concurrent-ruby', '~> 1'
  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'thin', '~> 1.7'
  spec.add_dependency 'rack-contrib', '~> 1.4'
  spec.add_dependency 'rack-token_auth', '~> 0.1'
  spec.add_dependency 'json', '~> 2'

  # Development
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'knapsack', '~> 1.13'
end
