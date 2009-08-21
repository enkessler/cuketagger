#!/usr/bin/env ruby

require "rubygems"
require "cucumber"
require "cucumber/feature_file"
require "cucumber/formatter/pretty"

class Tagger
  USAGE = "#{File.basename $0} [-f|--force] [add|remove]:TAG [FILE[:LINE]]+"

  def self.execute(args)
    new.execute(args)
  end

  def execute(args)
    abort(USAGE) if args.empty?
    opts = {:dry_run => true, :source => true}

    args.each do |arg|
      case arg
      when /^(.+?\.feature)(:\d+)?$/
        add_feature($1, $2)
      when /^(add|remove):(.+?)$/
        alterations << [$1.to_sym, $2]
      when /^(-f|--force)$/
        opts[:autoformat] = "."
        opts[:source] = false
        Term::ANSIColor.coloring = false
      else
        raise ArgumentError, "unknown argument: #{arg.inspect}"
      end
    end

    features.accept TagVisitor.new(self, step_mother, $stdout, opts)
  end

  def process(feature, element, tag_names)
    return unless should_alter?(feature, element)

    alterations.each do |op, tag_name|
      case op
      when :add
        tag_names.push tag_name
      when :remove
        tag_names.delete tag_name
      end
    end
  end

  def should_alter?(feature, element)
    line = element ? element.line : 0
    features_to_change.include? [feature.file, line]
  end

  private

  def add_feature(path, line)
    ff = Cucumber::FeatureFile.new(path).parse(step_mother, {})
    features_to_change << [path, line.to_s[1,1].to_i]
    features.add_feature ff
  end

  def step_mother
    @step_mother ||= Cucumber::StepMother.new
  end

  def features
    @features ||= Cucumber::Ast::Features.new
  end

  def alterations
    @alterations ||= []
  end

  def features_to_change
    @features_to_change ||= []
  end

end


class TagVisitor < Cucumber::Formatter::Pretty

  def initialize(tagger, step_mother, io, options)
    @tagger = tagger
    super(step_mother, io, options)
  end


  def visit_feature(feature)
    @in = :feature
    @current_feature = feature
    super
  end

  def visit_feature_element(element)
    @current_element = element
    super
  end

  def visit_tags(tags)
    @tagger.process(@current_feature, @current_element, tags.instance_variable_get("@tag_names"))
    super
  end

  private

  def record_tag_occurrences(*args)
    # override to avoid error if options[:include_tags] is not Enumerable
  end

end

if __FILE__ == $0
  Tagger.execute(ARGV)
end
