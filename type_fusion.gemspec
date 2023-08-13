# frozen_string_literal: true

require_relative "lib/type_fusion/version"

Gem::Specification.new do |spec|
  spec.name = "type_fusion"
  spec.version = TypeFusion::VERSION
  spec.authors = ["Marco Roth"]
  spec.email = ["marco.roth@intergga.ch"]

  spec.summary = "Community-contributed sample data for Ruby types"
  spec.description = spec.summary
  spec.homepage = "https://github.com/marcoroth/type_fusion"
  spec.required_ruby_version = ">= 2.7.0"

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "lhc"
  spec.add_dependency "litejob"
end
