module CukeTaggerHelper

  ROOT = File.expand_path "#{File.dirname(__FILE__)}/.."

  def self.run_cuketagger(args)
    %x{#{cuketagger} #{args} 2>&1}
  end

  def self.cuketagger
    "ruby -W0 #{'-d ' if $DEBUG} #{ROOT}/exe/cuketagger"
  end

end
