# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'digicert/api/version'

Gem::Specification.new do |spec|
  spec.name          = "digicert-api"
  spec.version       = Digicert::Api::VERSION
  spec.authors       = ["Ronald Tse"]
  spec.email         = ["ronald.tse@ribose.com"]

  spec.summary       = %q{Digicert Ruby API.}
  spec.description   = %q{Digicert Ruby API.}
  spec.homepage      = "https://www.ribose.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://gems.ribose.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curb"
  spec.add_dependency "json"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
