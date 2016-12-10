this_dir = File.dirname(__FILE__)

require "rspec/expectations"

require "#{this_dir}/../../../cuke_tagger_helper"
require "#{this_dir}/../../../../lib/cuketagger"


After do
  @created_files.each { |f| File.delete(f) }
end
