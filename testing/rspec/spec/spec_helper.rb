this_dir = File.dirname(__FILE__)

require "#{this_dir}/../../cuke_tagger_helper"
require "#{this_dir}/../../../lib/cuketagger"


RSpec.configure do |config|

  config.before(:all) do
    @default_file_directory = "#{this_dir}/temp_files"
    @default_feature_file_name = 'test_feature.feature'

    logfile = 'ct_logfile.txt'
    File.delete(logfile) if File.exists?(logfile)
  end

  config.before(:all) do |spec|
    FileUtils.remove_dir(@default_file_directory, true) if File.exists?(@default_file_directory)

    FileUtils.mkdir(@default_file_directory)
  end

  config.after(:all) do |spec|
    FileUtils.remove_dir(@default_file_directory, true)
  end

end
