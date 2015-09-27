# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hey/version"

Gem::Specification.new do |spec|
  spec.name          = "hey-pubsub"
  spec.version       = Hey::VERSION
  spec.authors       = ["ShippingEasy"]
  spec.email         = ["dev@shippingeasy.com"]

  spec.summary       = %q{Pubsub wrapper with utilities to chain events, sanitize payloads and record data on all events on the same thread.}
  spec.homepage      = "https://github.com/ShippingEasy/hey-pubsub"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "activesupport"
  spec.add_dependency "faraday_middleware"
end
