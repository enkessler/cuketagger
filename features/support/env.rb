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
    stdin, stdout, stderr = popen3("#{cuketagger} #{args}")
    [stdout.read, stderr.read]
  ensure
    [stdin, stdout, stderr].each { |e| e.close }
  end
  
  def cuketagger
    "ruby -rubygems #{ROOT}/bin/cuketagger"
  end
end

World(CukeTaggerHelper)

After do
  @created_files.each { |f| File.delete(f) }
end