require 'bundler/gem_tasks'
require 'rake'
require 'rainbow'

Rainbow.enabled = true

require_relative 'cuketagger_project_settings'
require_relative 'cuketagger_helper'
require_relative 'rakefiles/documentation_tasks'
require_relative 'rakefiles/other_tasks'
require_relative 'rakefiles/release_tasks'
require_relative 'rakefiles/reporting_tasks'
require_relative 'rakefiles/testing_tasks'


task :default => 'cuketagger:test_everything' # rubocop:disable Style/HashSyntax
