# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuketagger/version'

Gem::Specification.new do |spec|
  spec.name          = "cuketagger"
  spec.version       = CukeTagger::VERSION
  spec.authors       = ["Jari Bakken", "Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]

  # todo - Update summary and description with something better
  spec.summary       = "Batch tagging of cucumber features and scenarios"
  spec.description   = 'Allows for tagging various elements of a Cucumber test suite'
  spec.homepage      = "https://github.com/enkessler/cuketagger"
  spec.license       = "MIT"
  spec.metadata      = {
    'bug_tracker_uri'   => 'https://github.com/enkessler/cuketagger/issues',
    'changelog_uri'     => 'https://github.com/enkessler/cuketagger/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/cuketagger',
    'homepage_uri'      => 'https://github.com/enkessler/cuketagger',
    'source_code_uri'   => 'https://github.com/enkessler/cuketagger'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('', __dir__)) do
    source_controlled_files = `git ls-files -z`.split("\x0")
    source_controlled_files.keep_if { |file| file =~ /^(?:lib|exe)/ }
    source_controlled_files + ['README.md', 'LICENSE.txt', 'CHANGELOG.md', 'cuketagger.gemspec']
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0', '< 4.0'

  spec.add_runtime_dependency 'cuke_modeler', '>= 1.0', '< 4.0'
  spec.add_runtime_dependency 'cql', '~>1.0', '>= 1.3.0'

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'childprocess', '< 5.0'
  spec.add_development_dependency 'ffi', '< 2.0' # This is an invisible dependency for the `childprocess` gem on Windows
  spec.add_development_dependency 'rainbow', '< 4.0.0'
  spec.add_development_dependency 'rake', '< 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '<= 0.50.0' # RuboCop can not lint against Ruby 2.0 after this version
  spec.add_development_dependency 'cucumber', '< 8.0.0'
  spec.add_development_dependency 'simplecov', '< 1.0.0'
  spec.add_development_dependency 'simplecov-lcov', '< 1.0'
  spec.add_development_dependency 'yard', '< 1.0'
end
