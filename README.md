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

## Usage

```ruby
require "type_fusion"
```

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
#      gem_and_version="nokogiri-1.15.4-x86_64-darwin",
#      receiver="Nokogiri",
#      method_name=:parse,
#      location=[
#        "/Users/marcoroth/.anyenv/envs/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.15.4-x86_64-darwin/lib/nokogiri.rb",
#        43
#      ],
#      parameters=[
#        [:string, :req, String],
#        [:url, :opt, NilClass],
#        [:encoding, :opt, NilClass],
#        [:options, :opt, NilClass]
#      ]
#     >
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/type_fusion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/marcoroth/type_fusion/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the TypeFusion project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/marcoroth/type_fusion/blob/main/CODE_OF_CONDUCT.md).
