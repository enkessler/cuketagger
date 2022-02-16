module CukeTagger
  # The class responsible for tagging things
  class Tagger
    # The expected format of a cuketagger command
    USAGE = "#{File.basename $0} [-v|--version] [-f|--force] [add|remove|replace]:TAG[:REPLACEMENT] [FILE[:LINE]]+"

    # Performs tagging based on the provided arguments
    def self.execute(args)
      new.execute(args)
    end

    # Performs tagging based on the provided arguments
    def execute(args)
      abort(USAGE) if args.empty? || args.first =~ /^(-h|--help)$/

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

      files = features_to_change.map { |file, line| file }.uniq
      files.each { |file| parse file, force }
    end


    private


    def parse(file_path, write)
      return unless feature_to_change?(file_path)

      content = File.open(file_path) { |file| file.readlines }

      feature_model = CukeModeler::FeatureFile.new(file_path).feature

      io = write ? File.open(file_path, "w") : $stdout

      begin
        taggable_things = collect_taggable_models(feature_model)

        # Elements must be altered in the order that they appear in the file in order to
        # guarantee that any line adjustments are applied appropriately.
        taggable_things.sort!{|a,b| a.source_line <=> b.source_line}

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
      features_to_change.any? do |file, line|
        file == uri && (element.line == line || (line.nil? && element.kind_of?(Gherkin::Formatter::Model::Feature)))
      end
    end

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

    # todo - add warning if there are features that do not get changed (e.g. the user provided an incorrect file/line number or replaces a non-existant tag)
    def features_to_change
      @features_to_change ||= Set.new
    end

    def feature_to_change?(file_name)
      features_to_change.any? { |name, line_number| name == file_name }
    end

    def thing_to_tag?(thing)
      #todo - pass in file name as well for performance?
      features_to_change.any? { |name, line_number|
        name_match = (name == thing.get_ancestor(:feature_file).path)
        number_match = (thing.source_line == line_number)

        (name_match && number_match) || (name_match && thing.is_a?(CukeModeler::Feature) && line_number.nil?
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

      relevant_tag = thing.tags.select { |tag_model| tag_model.name == "@#{old_tag}" }.first

      if relevant_tag
        insertion_index = relevant_tag.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 1
        content[insertion_index] = content[insertion_index].sub("@#{old_tag}", "@#{new_tag}")
      else
        $stderr.puts "expected \"@#{old_tag}\" at #{thing.get_ancestor(:feature_file).name}:#{thing.source_line}, skipping"
      end
    end

    def add_tag(thing, tag, content)
      @file_offset ||= Hash.new(0)
      @line_removed ||= {}

      insertion_index = thing.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 2

      if new_line_needed?(thing, content, insertion_index)
        insertion_index += 1
        content.insert(insertion_index, '')

        @line_removed[thing] = false
        @file_offset[thing.get_ancestor(:feature_file).path] += 1
      end

      empty_line = content[insertion_index].chomp =~ /^\s*$/
      trim_line(content, insertion_index, !empty_line)

      content[insertion_index] = content[insertion_index].chomp + "#{tag_spacing(content, insertion_index)}@#{tag}\n"
    end

    def remove_tag(thing, tag, content)
      @file_offset ||= Hash.new(0)
      @line_removed ||= {}

      relevant_tag = thing.tags.select { |tag_model| tag_model.name == "@#{tag}" }.first

      return unless relevant_tag

      insertion_index = relevant_tag.source_line + @file_offset[thing.get_ancestor(:feature_file).path] - 1
      content[insertion_index] = content[insertion_index].sub(/@#{Regexp.escape(tag)} ?/, '')

      trim_line(content, insertion_index, true)

      if content[insertion_index] =~ /^\s*$/
        content[insertion_index] = nil
        content.compact!
        @file_offset[thing.get_ancestor(:feature_file).path] -= 1
        @line_removed[thing] = true
      end
    end

    def trim_line(content, insertion_index, keep_indentation)
      line_match = content[insertion_index].match(/^(\s*)(\S.*)?/)
      indentation = line_match[1]
      line_content = line_match[2]

      trimmed_line = keep_indentation ? indentation : ''
      trimmed_line += line_content.squeeze(' ').strip if line_content
      trimmed_line = "#{trimmed_line.chomp}\n"

      content[insertion_index] = trimmed_line
    end

    def tag_spacing(content, insertion_index)
      if content[insertion_index] =~ /\S/
        ' '
      else
        next_line_leading_spaces = content[insertion_index + 1].match(/^(\s*)/)[1]
        ' ' * next_line_leading_spaces.length
      end
    end

    def new_line_needed?(thing, content, insertion_index)
      line_was_removed?(thing) || (non_tag_line?(content, insertion_index) && non_empty_line?(content, insertion_index))
    end

    def line_was_removed?(thing)
      @line_removed[thing]
    end

    def non_tag_line?(content, insertion_index)
      content[insertion_index] !~ /^\s*@/
    end

    def non_empty_line?(content, insertion_index)
      content[insertion_index] !~ /^\s*$/
    end

  end
end
