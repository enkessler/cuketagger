# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuketagger/version'

Gem::Specification.new do |spec|
  spec.name          = "cuketagger"
  spec.version       = CukeTagger::VERSION
  spec.authors       = ["Jari Bakken", "Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]

  # todo - Update summary and description
  spec.summary       = "batch tagging of cucumber features and scenarios"
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/jarib/cuketagger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cuke_modeler', '~>1.0'
  spec.add_runtime_dependency 'cql', '~>1.0', '>= 1.3.0'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "racatt", '~> 1.0'
end
