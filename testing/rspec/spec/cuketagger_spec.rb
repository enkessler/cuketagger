require_relative '../../../environments/rspec_env'
require 'rubygems/mock_gem_ui'

RSpec.describe 'the gem' do

  let(:lib_folder) { "#{@root_dir}/lib" }
  let(:features_folder) { "#{@root_dir}/testing/cucumber/features" }
  let(:exe_folder) { "#{@root_dir}/exe" }

  before(:all) do
    @root_dir = "#{__dir__}/../../.."

    # Doing this as a one time hook instead of using `let` in order to reduce I/O time during testing.
    @gemspec = eval(File.read("#{@root_dir}/cuketagger.gemspec"))
  end

  it 'validates cleanly' do
    mock_ui = Gem::MockGemUi.new
    Gem::DefaultUserInteraction.use_ui(mock_ui) { @gemspec.validate }

    expect(mock_ui.error).to_not match(/warn/i)
  end

  it 'is named correctly' do
    expect(@gemspec.name).to eq('cuketagger')
  end

  it 'runs on Ruby' do
    expect(@gemspec.platform).to eq(Gem::Platform::RUBY)
  end

  it 'exposes its "lib" folder' do
    expect(@gemspec.require_paths).to match_array(['lib'])
  end

  it 'has a version' do
    expect(@gemspec.version.version).to eq(CukeTagger::VERSION)
  end

  it 'lists major authors' do
    expect(@gemspec.authors).to match_array(['Jari Bakken', 'Eric Kessler'])
  end

  it 'has contact emails for active maintainers' do
    expect(@gemspec.email).to match_array(['morrow748@gmail.com'])
  end

  it 'has a homepage' do
    expect(@gemspec.homepage).to eq('https://github.com/enkessler/cuketagger')
  end

  it 'has a summary' do
    text = <<-TEXT
        Batch tagging of cucumber features and scenarios
    TEXT
           .strip.squeeze(' ').delete("\n")

    expect(@gemspec.summary).to eq(text)
  end

  it 'has a description' do
    text = <<-TEXT
        Allows for tagging various elements of a Cucumber test suite
    TEXT
           .strip.squeeze(' ').delete("\n")

    expect(@gemspec.description).to eq(text)
  end

  describe 'license' do

    before(:all) do
      # Doing this as a one time hook instead of using `let` in order to reduce I/O time during testing.
      @license_text = File.read("#{@root_dir}/LICENSE.txt")
    end

    it 'has a current license' do
      expect(@license_text).to match(/Copyright.*2015-#{Time.now.year}/)
    end

    it 'uses the MIT license' do
      expect(@license_text).to include('MIT License')
      expect(@gemspec.licenses).to match_array(['MIT'])
    end

  end

  describe 'metadata' do

    it 'links to the changelog' do
      expect(@gemspec.metadata['changelog_uri']).to eq('https://github.com/enkessler/cuketagger/blob/master/CHANGELOG.md')
    end

    it 'links to the known issues/bugs' do
      expect(@gemspec.metadata['bug_tracker_uri']).to eq('https://github.com/enkessler/cuketagger/issues')
    end

    it 'links to the source code' do
      expect(@gemspec.metadata['source_code_uri']).to eq('https://github.com/enkessler/cuketagger')
    end

    it 'links to the home page of the project' do
      expect(@gemspec.metadata['homepage_uri']).to eq(@gemspec.homepage)
    end

    it 'links to the gem documentation' do
      expect(@gemspec.metadata['documentation_uri']).to eq('https://www.rubydoc.info/gems/cuketagger')
    end

  end

  describe 'included files' do

    it 'does not include files that are not source controlled' do
      bad_file_1 = File.absolute_path("#{lib_folder}/foo.txt")
      bad_file_2 = File.absolute_path("#{exe_folder}/foo.txt")
      bad_file_3 = File.absolute_path("#{features_folder}/foo.txt")

      begin
        FileUtils.touch(bad_file_1)
        FileUtils.touch(bad_file_2)
        FileUtils.touch(bad_file_3)

        gem_files = @gemspec.files.map { |file| File.absolute_path(file) }

        expect(gem_files).to_not include(bad_file_1, bad_file_2, bad_file_3)
      ensure
        FileUtils.rm([bad_file_1, bad_file_2, bad_file_3])
      end
    end

    it 'does not include just any source controlled file' do
      some_files_not_to_include = ['.github/workflows/ci.yml', 'Gemfile', 'Rakefile']

      some_files_not_to_include.each do |file|
        expect(@gemspec.files).to_not include(file)
      end
    end

    it 'includes all of the library files' do
      lib_files = Dir.chdir(@root_dir) do
        Dir.glob('lib/**/*').reject { |file| File.directory?(file) }
      end

      expect(@gemspec.files).to include(*lib_files)
    end

    it 'includes all of the executable files' do
      exe_files = Dir.chdir(@root_dir) do
        Dir.glob('exe/**/*').reject { |file| File.directory?(file) }
      end

      expect(@gemspec.files).to include(*exe_files)
    end

    it 'includes the README file' do
      readme_file = 'README.md'

      expect(@gemspec.files).to include(readme_file)
    end

    it 'includes the license file' do
      license_file = 'LICENSE.txt'

      expect(@gemspec.files).to include(license_file)
    end

    it 'includes the CHANGELOG file' do
      changelog_file = 'CHANGELOG.md'

      expect(@gemspec.files).to include(changelog_file)
    end

    it 'includes the gemspec file' do
      gemspec_file = 'cuketagger.gemspec'

      expect(@gemspec.files).to include(gemspec_file)
    end

  end

  it 'has an executable' do
    expect(@gemspec.executables).to eq(['cuketagger'])
  end

  describe 'dependencies' do

    it 'works with Ruby 2 and 3' do
      ruby_version_limits = @gemspec.required_ruby_version.requirements.map(&:join)

      expect(ruby_version_limits).to match_array(['>=2.0', '<4.0'])
    end

    it 'works with CukeModeler 1-3' do
      cuke_modeler_version_limits = @gemspec.dependencies
                                            .find do |dependency|
        (dependency.type == :runtime) &&
          (dependency.name == 'cuke_modeler')
      end
                                            .requirement.requirements.map(&:join)

      expect(cuke_modeler_version_limits).to match_array(['>=1.0', '<4.0'])
    end

    it 'works with CQL 1' do
      cuke_modeler_version_limits = @gemspec.dependencies
                                            .find do |dependency|
        (dependency.type == :runtime) &&
          (dependency.name == 'cql')
      end
                                            .requirement.requirements.map(&:join)

      expect(cuke_modeler_version_limits).to match_array(['~>1.0', '>=1.3.0'])
    end

  end

end

RSpec.describe CukeTagger do

  it 'has a version number' do
    expect(CukeTagger::VERSION).not_to be nil
  end

end
