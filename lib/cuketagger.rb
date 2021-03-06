$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "set"
require 'cuke_modeler'
require 'cql'
require 'cql/model_dsl'

require "cuketagger/version"
require "cuketagger/tagger"
require "cuketagger/array_list_extension" if defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"

module CukeTagger
end
