require "cucumber/cli/options"

module CukeTagger
  class Tagger
    USAGE = "#{File.basename $0} [-v|--version] [-f|--force] [add|remove|replace]:TAG[:REPLACEMENT] [FILE[:LINE]]+"

    def self.execute(args)
      new.execute(args)
    end

    def execute(args)
      abort(USAGE) if args.empty? || args.first =~ /^(-h|--help)$/
      CukeTagger.log :args, args

      cuke_args = %w[--dry-run]

      args.each do |arg|
        case arg
        when /^-v|--version$/
          puts CukeTagger::Version
        when /^(.+?\.feature)((:\d+)*)$/
          add_feature($1, $2.to_s)
        when /^(add|remove):(.+?)$/
          alterations << [$1.to_sym, $2]
        when /^(replace):(.+?):(.+)$/
          alterations << [$1.to_sym, [$2, $3]]
        when /^(-f|--force)$/
          cuke_args << "--autoformat" << "."
          cuke_args << "--no-source"
          Term::ANSIColor.coloring = false
        else
          abort(USAGE)
        end
      end

      alterations.uniq!

      CukeTagger.log :alterations, alterations

      configuration = Cucumber::Cli::Configuration.new
      configuration.parse!(cuke_args)

      formatter = Cucumber::Formatter::Pretty.new(runtime, $stdout, configuration.instance_variable_get("@options"))
      formatter.extend(TagFormatter)
      formatter.tagger = self

      walker = Cucumber::Ast::TreeWalker.new(runtime, [formatter], configuration)
      walker.visit_features features
    end

    def process(feature, element, tag_names)
      CukeTagger.log :process, :element => element.class
      return unless should_alter?(feature, element)

      alterations.each do |op, tag_name|
        case op
        when :add
          tag_names.push "@#{tag_name}"
        when :remove
          tag_names.delete "@#{tag_name}"
        when :replace
          idx = tag_names.index "@#{tag_name.first}"
          if idx.nil?
            $stderr.puts "expected #{tag_name.first.inspect} at #{file_and_line_for(feature, element).join(":")}, skipping"
          else
            tag_names[idx] = "@#{tag_name.last}"
          end
        end
      end
    end

    def should_alter?(feature, element)
      fl = file_and_line_for(feature, element)

      CukeTagger.log(:file_and_line => fl, :features_to_change => features_to_change)

      features_to_change.include? fl
    end

    private

    def file_and_line_for(feature, element)
      line = if element.respond_to?(:line)
               element.line
             elsif element.kind_of?(Cucumber::Ast::ScenarioOutline)
               element.instance_variable_get("@line")
             else
               0
             end

      [feature.file, line]
    end

    def add_feature(path, lines)
      ff = Cucumber::FeatureFile.new(path).parse({}, {})

      lines = lines.split(":")
      lines.delete("")

      if lines.empty?
        features_to_change << [path, 0]
      else
        lines.each do |line|
          features_to_change << [path, Integer(line)]
        end
      end

      features.add_feature ff
    end

    def runtime
      @runtime ||= Cucumber::Runtime.new
    end

    def features
      @features ||= Cucumber::Ast::Features.new
    end

    def alterations
      @alterations ||= []
    end

    def features_to_change
      @features_to_change ||= Set.new
    end

  end
end
