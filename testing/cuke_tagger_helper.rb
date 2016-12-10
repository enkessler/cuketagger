require "open3"


module CukeTaggerHelper
  extend Open3

  @@file_count = 1
  ROOT = File.expand_path "#{File.dirname(__FILE__)}/.."

  def self.create_file(file_name, file_content)
    File.open(file_name, 'w') { |f| f << file_content }
  end

  def self.run_cuketagger(args)
    %x{#{cuketagger} #{args} 2>&1}
  end

  def self.cuketagger
    "ruby -W0 -rubygems #{'-d ' if $DEBUG} #{ROOT}/bin/cuketagger"
  end

  def self.log_message(message)
    File.open('ct_logfile.txt', 'a') { |file| file.puts message }
  end

  def self.save_file(content)
    File.write("target_file_#{@@file_count}.feature", content)
    @@file_count += 1
  end

end
