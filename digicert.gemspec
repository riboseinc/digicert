# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "digicert/version"

Gem::Specification.new do |spec|
  spec.name          = "digicert"
  spec.version       = Digicert::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["operations@ribose.com"]

  spec.summary       = %q{Digicert Ruby API.}
  spec.description   = %q{Digicert Ruby API.}
  spec.homepage      = "https://www.ribose.com"
  spec.license       = "MIT"

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")
  spec.required_ruby_version = Gem::Requirement.new(">= 2.1.9")

  spec.add_dependency "r509", "~> 1.0"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"
end
