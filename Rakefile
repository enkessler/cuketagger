# encoding: utf-8

require "rake/clean"
require "rake/gempackagetask"

CLEAN.include %w[pkg]

GEM_NAME = "cuketagger"
GEM_VERSION = "0.1"

spec = Gem::Specification.new do |s|
  s.name             = GEM_NAME
  s.version          = GEM_VERSION
  s.has_rdoc         = false
  s.summary          = "batch tagging of cucumber features and scenarios"
  s.description      = s.summary
  s.authors          = %w[Jari Bakken]
  s.email            = "jari.bakken@gmail.com"
  s.homepage         = "http://cukes.info"
  s.bindir           = 'bin'
  s.executables      = Dir['bin/*'].map { |f| File.basename(f) }
  s.add_runtime_dependency 'cucumber', '>= 0.3.96'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

namespace :gem do
  desc "install the gem locally"
  task :install => [:package] do
    sh %{sudo #{Gem.ruby} -S gem install pkg/#{GEM_NAME}-#{GEM_VERSION}}
  end

  desc "Create a .gemspec file"
  task :spec do
    file = "#{GEM_NAME.downcase}.gemspec"
    File.unlink file if ::File.exists?(file)
    File.open(file, "w+") { |f| f << spec.to_ruby }
  end
end

