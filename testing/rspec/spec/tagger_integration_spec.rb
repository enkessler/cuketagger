require "#{File.dirname(__FILE__)}/spec_helper"


describe 'Tagger, Integration' do

  clazz = CukeTagger::Tagger

  let(:tagger) { clazz.new }
  let(:source_text) { ['',
                       'Feature:',
                       '',
                       'Scenario:',
                       '  * a step',
                       '',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n") }
  let(:file_path) { "#{@default_file_directory}/#{@default_feature_file_name}" }

  before(:each) do
    File.open(file_path, 'w') { |file| file.write(source_text) }
  end


  describe 'adding tags' do

    it 'can add a tag to a file' do
      args = "add:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can add a tag to a part of a file' do
      args = "add:bar #{file_path}:4"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['',
                            'Feature:',
                            '@bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can intermix full and partial file taggings' do
      args = "add:bar #{file_path} #{file_path}:7"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '@bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'tags multiple files' do
      source_text_1 = ['',
                       'Feature: Foo',
                       '',
                       'Scenario:',
                       '  * a step',
                       '',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       'Examples:',
                       '  | param |',
                       '  | value |',
                       ''].join("\n")

      source_text_2 = ['',
                       'Feature: Bar',
                       '',
                       'Scenario:',
                       '  * a step',
                       '',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

      File.open("#{@default_file_directory}/foo.feature", 'w') { |file_1| file_1.write(source_text_1) }
      File.open("#{@default_file_directory}/bar.feature", 'w') { |file_2| file_2.write(source_text_2) }

      args = "add:foo #{@default_file_directory}/foo.feature #{@default_file_directory}/bar.feature"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to include(['@foo',
                                 'Feature: Foo',
                                 '',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))

      expect(output).to include(['@foo',
                                 'Feature: Bar',
                                 '',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))
    end

    it 'correctly adds a tag to a feature' do
      args = "add:bar #{file_path}:2"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly adds a tag to a scenario' do
      args = "add:bar #{file_path}:4"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['',
                            'Feature:',
                            '@bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly adds a tag to an outline' do
      args = "add:bar #{file_path}:7"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '@bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly adds a tag to an example' do
      args = "add:bar #{file_path}:10"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '@bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly tags multiple parts of a file' do
      args = "add:bar #{file_path}:2 #{file_path}:7"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '@bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end


    describe 'tag indentation' do

      it 'correctly adds new tags to the end of an empty tag line' do
        source_text = ['',
                       '    Feature:',
                       '               ',
                       'Scenario:',
                       '  * a step',
                       ' ',
                       '  Scenario Outline:',
                       '    * a step',
                       '        ',
                       '        Examples:',
                       '          | param |',
                       '          | value |'].join("\n")

        File.open("#{file_path}", 'w') { |file| file.write(source_text) }

        args = "add:bar #{file_path}:2 #{file_path}:4 #{file_path}:7 #{file_path}:10"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['    @bar',
                              '    Feature:',
                              '@bar',
                              'Scenario:',
                              '  * a step',
                              '  @bar',
                              '  Scenario Outline:',
                              '    * a step',
                              '        @bar',
                              '        Examples:',
                              '          | param |',
                              '          | value |'].join("\n"))
      end

      it 'correctly adds new tags to the end of a full tag line' do
        source_text = ['@existing_tag',
                       '    Feature:',
                       '               @existing_tag',
                       'Scenario:',
                       '  * a step',
                       ' @existing_tag',
                       '  Scenario Outline:',
                       '    * a step',
                       '        @existing_tag',
                       '        Examples:',
                       '          | param |',
                       '          | value |'].join("\n")

        File.open("#{file_path}", 'w') { |file| file.write(source_text) }

        args = "add:bar #{file_path}:2 #{file_path}:4 #{file_path}:7 #{file_path}:10"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['@existing_tag @bar',
                              '    Feature:',
                              '               @existing_tag @bar',
                              'Scenario:',
                              '  * a step',
                              ' @existing_tag @bar',
                              '  Scenario Outline:',
                              '    * a step',
                              '        @existing_tag @bar',
                              '        Examples:',
                              '          | param |',
                              '          | value |'].join("\n"))
      end

    end

    it 'trims extra whitespace from a line when adding new tags' do
      source_text = ['                             ',
                     'Feature:',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open("#{file_path}", 'w') { |file| file.write(source_text) }

      args = "add:foo #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'ignores duplicate tag addition arguments' do
      args = "add:bar add:bar add:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end


    describe 'line adjustments' do

      it 'will add a new line above an element if no tag line or blank line exists' do
        source_text = ['',
                       'Feature:',
                       '# A comment',
                       'Scenario:',
                       '  * a step',
                       '',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

        File.open("#{file_path}", 'w') { |file| file.write(source_text) }

        args = "add:foo #{file_path}:4"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['',
                              'Feature:',
                              '# A comment',
                              '@foo',
                              'Scenario:',
                              '  * a step',
                              '',
                              'Scenario Outline:',
                              '  * a step',
                              '',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

      it 'correctly adds new lines to multiple parts of a file' do
        source_text = ['# A comment',
                       'Feature:',
                       '# A comment',
                       'Scenario:',
                       '  * a step',
                       '# A comment',
                       'Scenario Outline:',
                       '  * a step',
                       '# A comment',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

        File.open("#{file_path}", 'w') { |file| file.write(source_text) }

        args = "add:foo #{file_path}:2 #{file_path}:4 #{file_path}:7 #{file_path}:10"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['# A comment',
                              '@foo',
                              'Feature:',
                              '# A comment',
                              '@foo',
                              'Scenario:',
                              '  * a step',
                              '# A comment',
                              '@foo',
                              'Scenario Outline:',
                              '  * a step',
                              '# A comment',
                              '@foo',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

      it 'correctly adds a new line to the beginning of a file' do
        source_text = ['Feature:',
                       '',
                       'Scenario:',
                       '  * a step',
                       '',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

        File.open("#{file_path}", 'w') { |file| file.write(source_text) }

        args = "add:foo #{file_path}"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['@foo',
                              'Feature:',
                              '',
                              'Scenario:',
                              '  * a step',
                              '',
                              'Scenario Outline:',
                              '  * a step',
                              '',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

    end

  end


  describe 'removing tags' do

    let(:source_text) { ['@foo @bar',
                         'Feature:',
                         '',
                         '@foo @bar',
                         'Scenario:',
                         '  * a step',
                         '',
                         '@foo @bar',
                         'Scenario Outline:',
                         '  * a step',
                         '',
                         '@foo @bar',
                         'Examples:',
                         '  | param |',
                         '  | value |'].join("\n") }


    it 'can remove a tag from a file' do
      args = "remove:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can remove a tag from a part of a file' do
      args = "remove:bar #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly removes a tag that is not immediately above its element' do
      source_text = ['@foo @bar',
                     'Feature:',
                     '',
                     '',
                     '@foo @bar',
                     '',
                     '@baz',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     '@foo @bar',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     '@foo @bar',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "remove:foo remove:baz #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '',
                            '@bar',
                            '',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can handle removing a tag from an element that does not have it' do
      args = "remove:not_a_real_tag #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can intermix full and partial file tag removals' do
      args = "remove:bar #{file_path} #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'removes tags from multiple files' do
      source_text_1 = ['@foo @bar',
                       'Feature: Foo',
                       '',
                       '@foo @bar',
                       'Scenario:',
                       '  * a step',
                       '',
                       '@foo @bar',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       '@foo @bar',
                       'Examples:',
                       '  | param |',
                       '  | value |',
                       ''].join("\n")
      source_text_2 = ['@foo @bar',
                       'Feature: Bar',
                       '',
                       '@foo @bar',
                       'Scenario:',
                       '  * a step',
                       '',
                       '@foo @bar',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       '@foo @bar',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

      File.open("#{@default_file_directory}/foo.feature", 'w') { |file_1| file_1.write(source_text_1) }
      File.open("#{@default_file_directory}/bar.feature", 'w') { |file_2| file_2.write(source_text_2) }

      args = "remove:bar #{@default_file_directory}/foo.feature #{@default_file_directory}/bar.feature"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to include(['@foo',
                                 'Feature: Foo',
                                 '',
                                 '@foo @bar',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 '@foo @bar',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 '@foo @bar',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))

      expect(output).to include(['@foo',
                                 'Feature: Bar',
                                 '',
                                 '@foo @bar',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 '@foo @bar',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 '@foo @bar',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))
    end

    it 'correctly removes a tag from a feature' do
      args = "remove:bar #{file_path}:2"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly removes a tag from a scenario' do
      args = "remove:bar #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly removes a tag from an outline' do
      args = "remove:bar #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly removes a tag from an example' do
      args = "remove:bar #{file_path}:13"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly removes tags from multiple parts of a file' do
      args = "remove:bar #{file_path}:2 #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'trims extra whitespace from a line when removing tags' do
      source_text = ['@foo    @bar   @baz',
                     'Feature:',
                     '',
                     '@foo     @bar',
                     'Scenario:',
                     '  * a step',
                     '',
                     '@foo @bar     ',
                     'Scenario Outline:',
                     '  * a step',
                     '@bar @foo',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open("#{file_path}", 'w') { |file| file.write(source_text) }

      args = "remove:bar #{file_path}:2 #{file_path}:5 #{file_path}:9 #{file_path}:12"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @baz',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'ignores duplicate tag removal arguments' do
      source_text = ['@foo @bar @bar @bar',
                     'Feature:',
                     '',
                     '@foo @bar',
                     'Scenario:',
                     '  * a step',
                     '',
                     '@foo @bar',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     '@foo @bar',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "remove:bar remove:bar remove:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar @bar',
                            'Feature:',
                            '',
                            '@foo @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo @bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end


    describe 'line adjustments' do

      it 'will remove an existing line if it is empty after tag removal' do
        args = "remove:foo remove:bar #{file_path}:5"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['@foo @bar',
                              'Feature:',
                              '',
                              'Scenario:',
                              '  * a step',
                              '',
                              '@foo @bar',
                              'Scenario Outline:',
                              '  * a step',
                              '',
                              '@foo @bar',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

      it 'correctly removes empty lines from multiple parts of a file' do
        args = "remove:foo remove:bar #{file_path}:5 #{file_path}:13"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['@foo @bar',
                              'Feature:',
                              '',
                              'Scenario:',
                              '  * a step',
                              '',
                              '@foo @bar',
                              'Scenario Outline:',
                              '  * a step',
                              '',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

      it 'correctly removes an empty line from the beginning of a file' do
        args = "remove:foo remove:bar #{file_path}"

        output = CukeTaggerHelper.run_cuketagger(args)

        expect(output).to eq(['Feature:',
                              '',
                              '@foo @bar',
                              'Scenario:',
                              '  * a step',
                              '',
                              '@foo @bar',
                              'Scenario Outline:',
                              '  * a step',
                              '',
                              '@foo @bar',
                              'Examples:',
                              '  | param |',
                              '  | value |'].join("\n"))
      end

    end

  end


  describe 'replacing tags' do

    let(:source_text) { ['@foo',
                         'Feature:',
                         '',
                         '@foo',
                         'Scenario:',
                         '  * a step',
                         '',
                         '@foo',
                         'Scenario Outline:',
                         '  * a step',
                         '',
                         '@foo',
                         'Examples:',
                         '  | param |',
                         '  | value |'].join("\n") }


    it 'can replace a tag on a file' do
      args = "replace:foo:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can replace a tag on a part of a file' do
      args = "replace:foo:bar #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'can intermix full and partial file replacements' do
      args = "replace:foo:bar #{file_path} #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            '@bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly replaces a tag that is not immediately above its element' do
      source_text = ['Feature:',
                     '',
                     '',
                     '@foo @bar',
                     '',
                     '@baz',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "replace:foo:baz replace:baz:foo #{file_path}:8"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['Feature:',
                            '',
                            '',
                            '@baz @bar',
                            '',
                            '@foo',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'replaces tags in multiple files' do
      source_text_1 = ['@foo',
                       'Feature: Foo',
                       '',
                       '@foo',
                       'Scenario:',
                       '  * a step',
                       '',
                       '@foo',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       '@foo',
                       'Examples:',
                       '  | param |',
                       '  | value |',
                       ''].join("\n")
      source_text_2 = ['@foo',
                       'Feature: Bar',
                       '',
                       '@foo',
                       'Scenario:',
                       '  * a step',
                       '',
                       '@foo',
                       'Scenario Outline:',
                       '  * a step',
                       '',
                       '@foo',
                       'Examples:',
                       '  | param |',
                       '  | value |'].join("\n")

      File.open("#{@default_file_directory}/foo.feature", 'w') { |file_1| file_1.write(source_text_1) }
      File.open("#{@default_file_directory}/bar.feature", 'w') { |file_2| file_2.write(source_text_2) }

      args = "replace:foo:bar #{@default_file_directory}/foo.feature #{@default_file_directory}/bar.feature:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to include(['@bar',
                                 'Feature: Foo',
                                 '',
                                 '@foo',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))

      expect(output).to include(['@foo',
                                 'Feature: Bar',
                                 '',
                                 '@bar',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))
    end

    it 'correctly replaces a tag on a feature' do
      args = "replace:foo:bar #{file_path}:2"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly replaces a tag on a scenario' do
      args = "replace:foo:bar #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))

    end

    it 'correctly replaces a tag on an outline' do
      args = "replace:foo:bar #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@bar',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@foo',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))

    end

    it 'correctly replaces a tag on an example' do
      args = "replace:foo:bar #{file_path}:13"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'correctly replaces tags in multiple parts of a file' do
      args = "replace:foo:bar #{file_path}:2 #{file_path}:13"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar',
                            'Feature:',
                            '',
                            '@foo',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@foo',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            '@bar',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    # todo - emit notice when removing a tag that doesn't exist as well
    it 'emits a notice when replacing a tag from an element that does not have it' do
      args = "replace:not_a_real_tag:foo #{file_path}:5"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to include("expected \"@not_a_real_tag\" at #{File.basename(file_path)}:5, skipping")
      expect(output).to include(['@foo',
                                 'Feature:',
                                 '',
                                 '@foo',
                                 'Scenario:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Scenario Outline:',
                                 '  * a step',
                                 '',
                                 '@foo',
                                 'Examples:',
                                 '  | param |',
                                 '  | value |'].join("\n"))
    end

    it 'does not trim white extra whitespace when replacing tags' do
      source_text = ['@bar    @foo   @baz',
                     'Feature:',
                     '',
                     '   @foo     @bar',
                     'Scenario:',
                     '  * a step',
                     '',
                     '@bar @foo     ',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open("#{file_path}", 'w') { |file| file.write(source_text) }

      args = "replace:foo:new_tag #{file_path}:2 #{file_path}:5 #{file_path}:9"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@bar    @new_tag   @baz',
                            'Feature:',
                            '',
                            '   @new_tag     @bar',
                            'Scenario:',
                            '  * a step',
                            '',
                            '@bar @new_tag     ',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'ignores duplicate tag replacement arguments' do
      source_text = ['@bar @bar @bar',
                     'Feature:',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "replace:bar:foo replace:bar:foo replace:bar:foo #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bar @bar',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

  end


  describe 'intermixing actions' do

    it 'can intermix tag addition, removal, and replacement' do
      source_text = ['@foo @bar @baz',
                     'Feature:',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "add:new_tag remove:bar replace:baz:bazzz #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @bazzz @new_tag',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

    it 'applies tag actions in the order specified' do
      source_text = ['@foo @bar @baz',
                     'Feature:',
                     '',
                     'Scenario:',
                     '  * a step',
                     '',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open(file_path, 'w') { |file| file.write(source_text) }

      args = "remove:bar replace:bar:new_tag #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @baz',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))

      args = "replace:bar:new_tag remove:bar #{file_path}"

      output = CukeTaggerHelper.run_cuketagger(args)

      expect(output).to eq(['@foo @new_tag @baz',
                            'Feature:',
                            '',
                            'Scenario:',
                            '  * a step',
                            '',
                            'Scenario Outline:',
                            '  * a step',
                            '',
                            'Examples:',
                            '  | param |',
                            '  | value |'].join("\n"))
    end

  end


  describe 'rewriting files' do

    it 'does not rewrite a file by default' do
      args = "add:bar #{file_path}"

      CukeTaggerHelper.run_cuketagger(args)

      expect(File.read(file_path)).to eq(['',
                                          'Feature:',
                                          '',
                                          'Scenario:',
                                          '  * a step',
                                          '',
                                          'Scenario Outline:',
                                          '  * a step',
                                          '',
                                          'Examples:',
                                          '  | param |',
                                          '  | value |'].join("\n"))
    end

    it 'rewrites a file when forced' do
      args = "add:bar #{file_path} -f"

      CukeTaggerHelper.run_cuketagger(args)

      expect(File.read(file_path)).to eq(['@bar',
                                          'Feature:',
                                          '',
                                          'Scenario:',
                                          '  * a step',
                                          '',
                                          'Scenario Outline:',
                                          '  * a step',
                                          '',
                                          'Examples:',
                                          '  | param |',
                                          '  | value |'].join("\n"))
    end

  end


  describe 'arguments' do

    it 'can understand multiple changes in the same file' do
      source_text = ['@bar    @foo   @baz',
                     'Feature:',
                     '',
                     '   @foo     @bar',
                     'Scenario:',
                     '  * a step',
                     '',
                     '@bar @foo     ',
                     'Scenario Outline:',
                     '  * a step',
                     '',
                     'Examples:',
                     '  | param |',
                     '  | value |'].join("\n")

      File.open("#{file_path}", 'w') { |file| file.write(source_text) }

      args = "replace:foo:new_tag #{file_path}:2 #{file_path}:5 #{file_path}:9"
      separate_output = CukeTaggerHelper.run_cuketagger(args)

      args = "replace:foo:new_tag #{file_path}:2:5:9"
      combined_output = CukeTaggerHelper.run_cuketagger(args)

      expect(separate_output).to eq(combined_output)
    end

    it 'does other things' do
      skip('write more argument tests')
    end

  end

end
