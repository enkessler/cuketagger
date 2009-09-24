module CukeTagger
  class Tagger
    USAGE = "#{File.basename $0} [-v|--version] [-f|--force] [add|remove|replace]:TAG[:REPLACEMENT] [FILE[:LINE]]+"

    def self.execute(args)
      new.execute(args)
    end

    def execute(args)
      abort(USAGE) if args.empty? || args.first =~ /^(-h|--help)$/
      opts = {:dry_run => true, :source => true}

      args.each do |arg|
        case arg
        when /^-v|--version$/
          puts CukeTagger::Version
        when /^(.+?\.feature)(:\d+)?$/
          add_feature($1, $2.to_s)
        when /^(add|remove):(.+?)$/
          alterations << [$1.to_sym, $2]
        when /^(replace):(.+?):(.+)$/
          alterations << [$1.to_sym, [$2, $3]]
        when /^(-f|--force)$/
          opts[:autoformat] = "."
          opts[:source] = false
          Term::ANSIColor.coloring = false
        else
          abort(USAGE)
        end
      end

      formatter = Cucumber::Formatter::Pretty.new(step_mother, $stdout, opts)
      formatter.extend(TagFormatter)
      formatter.tagger = self

      walker = Cucumber::Ast::TreeWalker.new(step_mother, [formatter], opts)
      walker.visit_features features
    end

    def process(feature, element, tag_names)
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
      features_to_change.include? fl
    end

    private

    def file_and_line_for(feature, element)
      line = element.respond_to?(:line) ? element.line : 0
      [feature.file, line]
    end

    def add_feature(path, line)
      ff = Cucumber::FeatureFile.new(path).parse(step_mother, {})
      features_to_change << [path, line[1,line.length].to_i]
      features.add_feature ff
    end

    def step_mother
      @step_mother ||= Cucumber::StepMother.new
    end

    def features
      @features ||= Cucumber::Ast::Features.new
    end

    def alterations
      @alterations ||= Set.new
    end

    def features_to_change
      @features_to_change ||= Set.new
    end

  end
end