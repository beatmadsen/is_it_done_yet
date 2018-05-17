# IsItDoneYet

A simple web app that stores key-value pairs to aid in coordinating build outcomes of parallel CI build pipelines such as Travis's matrix build feature.

The intended use case is when you want to use one of the build nodes as a master and wait for the results of the slaves before doing some final action.

Specifically I built it to allow a travis job at work to do parallel tests with Knapsack and do a deploy if all tests pass.

An example Travis build configuration that takes advantage of a deployed `is_it_done_yet` service is available in [examples](exampels/.travis.yml).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'is_it_done_yet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install is_it_done_yet

## Usage

This library includes a Rack application which you can instantiate by doing `IsItDoneYet.build_app`. In the [example Rack config](examples/config.ru) there's a setup with token-based auth middleware. Include a similar `config.ru` at the root of your application and run `bundle exec rackup` to start the web app locally. If you're running it on a cloud service, follow your service's guidelines on deploying Rack applications.

The web app provides five endpoints:
* `POST /builds/:build_id/nodes/:node_id` to write value for node, failing to overwrite.
    - example request body: `{ "build_state" : "ok" }`
* `PUT /builds/:build_id/nodes/:node_id` to write or overwrite value for node.
    - example request body: `{ "build_state" : "building", "build_state_on_overwrite" : "rebuilding" }`
* `GET /builds/:build_id`
    - example response body: `{ "build_states": { "51": "bad", "52": "ok" } }`
* `GET /builds/:build_id/nodes/:node_id`
    - example response body: `{ "build_state": "ok" }`
* `DELETE /builds/:build_id` to clear state for a build

The app keeps the build states in memory. This means that values will be lost after a restart of the service. Further, load balancing across multiple instances will only work if routing to the individual instance is consistent for the same `:build_id` path parameter, but scaling beyond one app instance is not currently a known use case.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beatmadsen/is_it_done_yet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
