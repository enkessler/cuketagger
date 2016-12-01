module CukeTagger
  class Tagger
    USAGE = "#{File.basename $0} [-v|--version] [-f|--force] [add|remove|replace]:TAG[:REPLACEMENT] [FILE[:LINE]]+"

    def self.execute(args)
      new.execute(args)
    end

    def execute(args)
      abort(USAGE) if args.empty? || args.first =~ /^(-h|--help)$/
      CukeTagger.log :args, args

      force = false

      args.each do |arg|
        case arg
        when /^-v|--version$/
          puts CukeTagger::Version
        when /^(.+?\.feature)((:\d+)*)$/
         add_feature $1, $2.to_s
        when /^(add|remove):(.+?)$/
          alterations << [$1.to_sym, $2]
        when /^(replace):(.+?):(.+)$/
          alterations << [$1.to_sym, [$2, $3]]
        when /^(-f|--force)$/
          force = true
        else
          abort(USAGE)
        end
      end

      alterations.uniq!

      CukeTagger.log :alterations, alterations

      files = features_to_change.map { |file, line| file }.uniq
      files.each { |file| parse file, force }
    end

    def parse(file, write)
      return unless feature_to_change?(file)

      content = File.open(file) { |file| file.readlines }

      feature_model = CukeModeler::FeatureFile.new(file).feature

      io = write ? File.open(file, "w") : $stdout

      begin
        taggable_things = collect_taggable_models(feature_model)

        taggable_things.each do |thing|
          if thing_to_tag?(thing)
            alterations.each do |alteration|
              alter_thing(thing, alteration, content)
            end
          end
        end

        content = content.join

        io.write(content)
      ensure
        io.close unless io == $stdout
      end
    end

    def should_alter?(uri, element)
      CukeTagger.log(:file_and_line => [uri, element.line], :features_to_change => features_to_change)

      features_to_change.any? do |file, line|
        file == uri && (element.line == line || (line.nil? && element.kind_of?(Gherkin::Formatter::Model::Feature)))
      end
    end

    private

    def add_feature(path, lines)
      lines = lines.split(":")
      lines.delete ""

      if lines.empty?
        features_to_change << [path, nil]
      else
        lines.each do |line|
          features_to_change << [path, Integer(line)]
        end
      end
    end

    def alterations
      @alterations ||= []
    end

    def features_to_change
      @features_to_change ||= Set.new
    end

    def feature_to_change?(file_name)
      features_to_change.any? { |name, line_number| name == file_name }
    end

    def thing_to_tag?(thing)
      #todo - pass in file name as well for performance?
      features_to_change.any? { |name, line_number|
        name_match =(name == thing.get_ancestor(:feature_file).name)
        number_match = (thing.source_line == line_number)
        (name_match && number_match) || (thing.is_a?(CukeModeler::Feature) && line_number.nil?
        )
      }
    end

    def collect_taggable_models(feature_model)
      results = feature_model.query do
        select :model
        from scenarios, outlines, examples
      end
      [feature_model] + results.collect { |result| result[:model] }
    end

    def alter_thing(thing, alteration, content)

      case alteration.first
        when :add
          add_tag(thing, alteration.last, content)
        when :remove
          remove_tag(thing, alteration.last, content)
        when :replace
          replace_tag(thing, alteration.last.first, alteration.last.last, content)
        else
          raise "Unknown alteration type: #{alteration.first}"
      end
    end

    def replace_tag(thing, old_tag, new_tag, content)
      @file_offset ||= Hash.new(0)
      @line_removed ||= {}
      insertion_index = thing.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 2


      if content[insertion_index] =~ /@#{old_tag}/
        content[insertion_index] = content[insertion_index].sub("@#{old_tag}", "@#{new_tag}")
      else
        $stderr.puts "expected \"@#{old_tag}\" at #{thing.get_ancestor(:feature_file).name}:#{thing.source_line}, skipping"
      end
    end

    def add_tag(thing, tag, content)
      @file_offset ||= Hash.new(0)
      @line_removed ||= {}
      insertion_index = thing.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 2
      insertion_index += 1 if @line_removed[thing]

      if @line_removed[thing]
        content.insert(insertion_index, '')
        @line_removed[thing] = false
      end

      content[insertion_index] = content[insertion_index].chomp + "#{tag_spacing(content[insertion_index])}@#{tag}\n"
    end

    def remove_tag(thing, tag, content)
      @file_offset ||= Hash.new(0)
      @line_removed ||= {}
      insertion_index = thing.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 2

      content[insertion_index] = content[insertion_index].sub("@#{tag}", '')
      if content[insertion_index] =~ /^\s*$/
        content[insertion_index] = nil
        content.compact!
        @file_offset[thing.get_ancestor(:feature_file).path] -= 1
        @line_removed[thing] = true
      end
    end

    def tag_spacing(line_text)
      line_text =~ /\S/ ? ' ' : ''
    end

  end
end
