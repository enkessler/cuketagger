$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__) || $LOAD_PATH.include?(File.expand_path(__dir__))

require 'set'
require 'cuke_modeler'
require 'cql'
require 'cql/model_dsl'

require 'cuketagger/version'
require 'cuketagger/tagger'

# The top level namespace for CukeTagger related code.
module CukeTagger
end
