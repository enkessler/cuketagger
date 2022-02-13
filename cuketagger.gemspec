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
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cuke_modeler', '>= 1.0', '< 4.0'
  spec.add_runtime_dependency 'cql', '~>1.0', '>= 1.3.0'

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'childprocess', '< 5.0'
  spec.add_development_dependency 'ffi', '< 2.0' # This is an invisible dependency for the `childprocess` gem on Windows
  spec.add_development_dependency 'rainbow', '< 4.0.0'
  spec.add_development_dependency 'rake', '< 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cucumber', '< 3.0.0'
  spec.add_development_dependency 'simplecov', '< 1.0.0'
  spec.add_development_dependency 'yard', '< 1.0'
end
