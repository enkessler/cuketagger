require 'simplecov-lcov'
require_relative 'cuketagger_helper'

SimpleCov.command_name(ENV['CUKETAGGER_SIMPLECOV_COMMAND_NAME'])

# Coveralls GitHub Action needs an lcov formatted file
SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.lcov_file_name = 'lcov.info'
end

# Also making a more friendly HTML file
formatters = [SimpleCov::Formatter::HTMLFormatter]

major, minor = CukeTagger::CukeTaggerHelper.version_of('simplecov')

# The Lcov formatter needs at least version 0.18 of SimpleCov but earlier versions may be in use due to CI needs
unless (major == 0) && (minor < 18)
  formatters << SimpleCov::Formatter::LcovFormatter
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)

SimpleCov.start do
  root __dir__
  coverage_dir "#{ENV['CUKETAGGER_REPORT_FOLDER']}/coverage"

  add_filter '/testing/'
  add_filter '/environments/'

  merge_timeout 300
end
