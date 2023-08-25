# TypeFusion

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add type_fusion
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install type_fusion
```

### Running TypeFusion in the `test` environment

Setup TypeFusion if you only want to run TypeFusion as part of your test suite.

#### Minitest

You can require `type_fusion/minitest` in your `test_helper.rb`:

```diff
# test/test_helper.rb

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

+require "type_fusion/minitest"

class ActiveSupport::TestCase
  # ...
end
```

#### RSpec

You can require `type_fusion/rspec` in your `spec_helper.rb`:

```diff
# spec/spec_helper.rb

+require "type_fusion/rspec"

RSpec.configure do |config|
  # ...
end
```

### Running TypeFusion in `development` or `production`

#### Rack

```ruby
require "type_fusion/rack/middleware"

use TypeFusion::Middleware
```

#### Rails

Adding the gem to your applications Gemfile will automatically setup `type_fusion`.



## Configuration

Setup `TypeFusion` in an initializer

```ruby
# config/initializers/type_fusion.rb

require "type_fusion"

TypeFusion.config do |config|

  # === application_name
  #
  # Set application_name to a string which is used to know where the samples
  # came from. Set application_name to an empty string if you wish to not
  # send the application name alongside the samples.
  #
  # Default: "TypeFusion"
  # Default when using Rails: Rails.application.class.module_parent_name
  #
  # config.application_name = "YourApplication"


  # === endpoint
  #
  # Set endpoint to an URL where TypeFusion should send the samples to.
  #
  # Default: "https://gem.sh/api/v1/types/samples"
  #
  # config.endpoint = "https://your-domain.com/api/v1/types/samples"


  # === type_sample_request
  #
  # Set type_sample_request to a lambda which resolves to true/false
  # to set if type sampling should be enabled for the whole rack request.
  #
  # Default: ->(rack_env) { [true, false, false, false].sample }
  #
  # config.type_sample_request = ->(rack_env) { [true, false, false, false].sample }


  # === type_sample_tracepoint_path
  #
  # Set type_sample_tracepoint_path to a lambda which resolves
  # to true/false to check if a tracepoint_path should be sampled
  # or not.
  #
  # This can be useful when you want to only sample method calls for
  # certain gems or want to exclude a gem from being sampled.
  #
  # Example:
  # config.type_sample_tracepoint_path = ->(tracepoint_path) {
  #   return false if tracepoint_path.include?("activerecord")
  #   return false if tracepoint_path.include?("sprockets")
  #   return false if tracepoint_path.include?("some-private-gem")
  #
  #   true
  # }
  #
  # Default: ->(tracepoint_path) { true }
  #
  # config.type_sample_tracepoint_path = ->(tracepoint_path) { true }


  # === type_sample_call_rate
  #
  # Set type_sample_call_rate to 1.0 to capture 100% of method calls
  # within a rack request.
  #
  # Default: 0.001
  #
  # config.type_sample_call_rate = 0.001
end
```

## Usage

#### Type sample inside a block

```ruby
TypeFusion.with_sampling do
  # run code you want to type sample here
end
```

#### Type sample globally

```ruby
TypeFusion.start

# run code you want to type sample here

TypeFusion.stop
```

#### Retrieve the samples

```ruby
TypeFusion::Sampler.instance.samples
# => [...]
```

```ruby
TypeFusion::Sampler.instance.samples.first

# => #<struct TypeFusion::SampleCall
#      gem_name="nokogiri"
#      gem_version="1.15.4-x86_64-darwin",
#      receiver="Nokogiri",
#      method_name=:parse,
#      application_name="TypeFusion",
#      location="/Users/marcoroth/.anyenv/envs/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.15.4-x86_64-darwin/lib/nokogiri.rb:43",
#      type_fusion_version="0.0.4",
#      parameters=[
#        [:string, :req, String],
#        [:url, :opt, NilClass],
#        [:encoding, :opt, NilClass],
#        [:options, :opt, NilClass]
#      ],
#      return_value="Nokogiri::XML::Document"
#     >
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/type_fusion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/marcoroth/type_fusion/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the TypeFusion project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/marcoroth/type_fusion/blob/main/CODE_OF_CONDUCT.md).
