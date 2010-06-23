# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cuketagger}
  s.version = "0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jari", "Bakken"]
  s.date = %q{2010-06-24}
  s.default_executable = %q{cuketagger}
  s.description = %q{batch tagging of cucumber features and scenarios}
  s.email = %q{jari.bakken@gmail.com}
  s.executables = ["cuketagger"]
  s.files = ["Rakefile", "README.markdown", "lib/cuketagger.rb", "lib/cuketagger", "lib/cuketagger/array_list_extension.rb", "lib/cuketagger/version.rb", "lib/cuketagger/tag_formatter.rb", "lib/cuketagger/tagger.rb", "bin/cuketagger"]
  s.homepage = %q{http://cukes.info}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{batch tagging of cucumber features and scenarios}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, [">= 0.3.103"])
    else
      s.add_dependency(%q<cucumber>, [">= 0.3.103"])
    end
  else
    s.add_dependency(%q<cucumber>, [">= 0.3.103"])
  end
end
