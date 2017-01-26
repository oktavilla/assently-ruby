# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'egree/version'

Gem::Specification.new do |spec|
  spec.name          = "egree"
  spec.version       = Egree::VERSION
  spec.authors       = ["Joel Junström"]
  spec.email         = ["joel.junstrom@oktavilla.se"]
  spec.summary       = %q{Client for the Egree API}
  spec.homepage      = "https://github.com/Oktavilla/egree-ruby"
  spec.license       = "MIT"

  spec.required_ruby_version = "~> 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "dotenv", "~> 2.1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock", "~> 2.3.2"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "luhn", "~> 1.0.2"
end
