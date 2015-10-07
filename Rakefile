# encoding: utf-8

require "rake/clean"
require "rake/gempackagetask"
require File.expand_path("../lib/cuketagger/version", __FILE__)
require "cucumber/rake/task"
CLEAN.include %w[pkg]

GEM_NAME = "cuketagger"
GEM_VERSION = CukeTagger::Version


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

  desc "Release cuketagger-#{GEM_VERSION}"
  task :release => [:clean, :gem] do
    sh "gem push pkg/#{GEM_NAME}-#{GEM_VERSION}.gem"
  end
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

task :default => :features
