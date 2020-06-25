# Omniauth::Protect

Protects your Rails app from Omniauth request phase CSRF vulnerability

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-protect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-protect

## Usage

Add this line to your `config/application.rb` to use the middleware

```ruby
config.middleware.use Omniauth::Protect::Middleware
```

Or use the validator on it's own

```ruby
Omniauth::Protect::Validator.new(request.env, encoded_masked_token).valid_csrf_token?
```

### Rails versions support

`omniauth-protect` `1.0.0` supports `rails < 5.2.4.3` and between `6.0.0` and `6.0.3`

`omniauth-protect` `2.0.0` supports `rails = 5.2.4.3`

`omniauth-protect` `3.0.0` supports `rails > 6.0.3.1`

## Configuration

You need to create an initiliazer like `config/initializers/omniauth_protect.rb` for configuration

```ruby
Omniauth::Protect.config[:message] = 'CSRF detected, Access Denied'
Omniauth::Protect.config[:paths] = ['/auth/twitter', '/auth/google' ,'/auth/github']
Omniauth::Protect.configure
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rainforestapp/omniauth-protect.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Thanks

Speacial thanks to [RainforestQA](https://www.rainforestqa.com/)
