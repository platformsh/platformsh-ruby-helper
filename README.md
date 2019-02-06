# Platform.sh
platform_sh is a helper gem to ease interacting with the environment of the Platform.sh PaaS

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'platform_sh'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install platform_sh

## Usage

    @config = PlatformSH::config

You could now use `@config["relationships"]["database"][0]` to get the configuration hash of the
database relationship.

The Gem can also export in the environment URLs that can be picked up by libraries for their configuration. 

    PlatformSH::export_services_urls

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/platformsh/platform_rb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

