$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "set"

require "gherkin"
require "gherkin/formatter/pretty_formatter"
require "stringio"

require "cuketagger/version"
require "cuketagger/tag_formatter"
require "cuketagger/tagger"
require "cuketagger/array_list_extension" if defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"

module CukeTagger
  def self.log(*args)
    File.open("/tmp/cuketagger.log", "a") { |file| file.puts args.inspect } if $DEBUG
  end
end
