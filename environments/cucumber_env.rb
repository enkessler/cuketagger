ENV['CUKETAGGER_SIMPLECOV_COMMAND_NAME'] = 'cucumber_tests'

require 'simplecov'
require_relative 'common_env'

require_relative '../testing/cucumber/step_definitions/cuketagger_steps'

World(CukeTagger::FileHelper)


Before do
  @root_test_directory = create_directory
end

at_exit {
  CukeTagger::FileHelper.delete_created_directories
}
