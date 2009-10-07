$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "cucumber"
require "cucumber/feature_file"
require "cucumber/formatter/pretty"
require "set"

require "cuketagger/version"
require "cuketagger/tag_formatter"
require "cuketagger/tagger"

module CukeTagger
  def self.log(*args)
    File.open("/tmp/cuketagger.log", "a") { |file| file.puts args.inspect } if $DEBUG
  end
end
