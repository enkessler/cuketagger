require 'fileutils'
require 'tmpdir'

module CukeTagger

  # A helper module that generates files and directories for use in testing
  module FileHelper

    module_function

    def created_directories
      @created_directories ||= []
    end

    def create_directory(options = {})
      options[:name]      ||= 'test_directory'
      options[:directory] ||= Dir.mktmpdir

      path = "#{options[:directory]}/#{options[:name]}"

      Dir.mkdir(path)
      created_directories << options[:directory]

      path
    end

    def create_feature_file(options = {})
      options[:text] ||= 'Feature:'
      options[:name] ||= 'test_file'

      create_file(text: options[:text], name: options[:name], extension: '.feature', directory: options[:directory])
    end

    def create_file(options = {})
      options[:text]      ||= ''
      options[:name]      ||= 'test_file'
      options[:extension] ||= '.txt'
      options[:directory] ||= create_directory

      file_path = "#{options[:directory]}/#{options[:name]}#{options[:extension]}"
      FileUtils.mkdir_p(File.dirname(file_path)) # Ensuring that the target directory already exists
      File.write(file_path, options[:text])

      file_path
    end

    def delete_created_directories
      created_directories.each do |dir_path|
        FileUtils.remove_entry(dir_path, true)
      end
    end

  end
end
