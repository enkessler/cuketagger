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
      content = File.read(file)

      io = write ? File.open(file, "w") : $stdout
      begin
        pretty_formatter = Gherkin::Formatter::PrettyFormatter.new(io,
                                                                  !(io == $stdout && $stdout.tty?), # monochrome
                                                                  false) # executing
        pretty_formatter.extend TagFormatter
        pretty_formatter.tagger = self

        parser = Gherkin::Parser::Parser.new(pretty_formatter, true)
        parser.parse content, file, 0
      ensure
        io.close unless io == $stdout
      end
    end

    def process(uri, element)
      CukeTagger.log :process, :element => element.class
      return unless should_alter?(uri, element)

      @uri = uri

      alterations.each do |op, tag_name|
        case op
        when :add
          push_tag element, "@#{tag_name}"
        when :remove
          remove_tag element, "@#{tag_name}"
        when :replace
          replace_tag element, tag_name
        end
      end
    end

    def push_tag(element, tag_name)
      element.tags << Gherkin::Formatter::Model::Tag.new(tag_name, element.line)
    end

    def remove_tag(element, tag_name)
      element.tags.delete_if { |tag| tag.name == tag_name }
    end

    def replace_tag(element, tag_name)
      to_replace, replacement = tag_name
      to_replace  = "@#{to_replace}"
      replacement = "@#{replacement}"

      idx = element.tags.find_index { |tag| tag.name == to_replace }

      if idx.nil?
        $stderr.puts "expected #{to_replace.inspect} at #{@uri}:#{element.line}, skipping"
      else
        element.tags[idx] = Gherkin::Formatter::Model::Tag.new(replacement, element.line)
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

  end
end
