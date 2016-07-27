Code Stats Metrics Reporter
===========================

[![Gem Version](https://badge.fury.io/rb/codestats-metrics-reporter.svg)](https://badge.fury.io/rb/codestats-metrics-reporter)

Ruby tasks gem to report metrics to [Code Stats](https://github.com/Wolox/codestats) from a Continous Integration service.

This gem is still alpha stage and it is not pushed to [Ruby Gems](https://rubygems.org/). It include those metrics that suit [Wolox](http://wolox.co) technologies. The idea es to leave this gem as a generic interface to [Code Stats](https://github.com/Wolox/codestats) that parses metrics from a folder. So you can generate a separate gem per metric that will leave metrics in that folder. The invocation would be something like this:

```bash
  bundle exec simplecov-code-stats-metric
  bundle exec rubycritic-code-stats-metric
  bundle exec code-stats-metrics-reporter
```

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'codestats-metrics-reporter'
```

And then execute:

```bash
  bundle
```

Or install it yourself as:

```bash
  gem install codestats-metrics-reporter
```

## Usage

The idea is to install this gem in your project and to let your Continous Integration to run certain scripts to push your metrics to your self-hosted Code Stats.

The default configuration for your metrics is in the [default.yml](config/default.yml), but you can create the `.codestats.yml` and replace those values. Because this gem accepts any kind of metric for any kind of language, framework, all the metrics are disabled by default, feel free to enable them by adding:

```ruby
  enabled: true
```

to your `.codestats.yml`. For example:

```ruby
metrics:
  simplecov:
    enabled: true
```

then you need to add to your CI file the following command after your build is success:

```ruby
  bundle exec codestats-metrics-reporter
```

and if you have the right configuration, you will see your metric value in Code Stats under your branch name.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rspec tests (`bundle exec rspec spec -fd`)
5. Run rubocop lint (`bundle exec rubocop spec lib bin`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

Feel free to add a new Issue by clicking [here](https://github.com/Wolox/codestats-metrics-reporter/issues/new) if you find a bug, idea of improvement, etc.

## About

This project is maintained by:

- [Esteban Guido Pintos](https://github.com/epintos)

and it is written by [Wolox](http://www.wolox.com.ar) under the [LICENSE](LICENSE) license.


![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

