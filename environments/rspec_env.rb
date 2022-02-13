ENV['CUKETAGGER_SIMPLECOV_COMMAND_NAME'] ||= 'rspec_tests'

require 'simplecov'
require_relative 'common_env'

require 'fileutils'

RSpec.configure do |config|

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Use 'expect' matcher syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # For running only specific tests with the 'focus' tag
  config.filter_run_when_matching focus: true

  config.before(:all) do
    logfile = 'ct_logfile.txt'
    File.delete(logfile) if File.exists?(logfile)
  end

  config.after(:suite) do
    CukeTagger::FileHelper.delete_created_directories
  end

  config.include CukeTagger::FileHelper
end
