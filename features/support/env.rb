require "#{File.dirname(__FILE__)}/../../lib/cuketagger"
require "spec/expectations"
require "open3"

module CukeTaggerHelper
  include Open3
  
  ROOT = File.expand_path "#{File.dirname(__FILE__)}/../.."
  
  def create_file(file_name, file_content)
    (@created_files ||= []) << file_name
    File.open(file_name, 'w') { |f| f << file_content }
  end
  
  def run_cuketagger(args)
    %x{#{cuketagger} #{args} 2>&1}
  end
  
  def cuketagger
    "ruby -W0 -rubygems #{ROOT}/bin/cuketagger"
  end
end

World(CukeTaggerHelper)

After do
  @created_files.each { |f| File.delete(f) }
end