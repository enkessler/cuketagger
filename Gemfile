source 'https://rubygems.org'

# Specify your gem's dependencies in cuketagger.gemspec
gemspec

if RUBY_VERSION =~ /^1\.8/
  gem 'cucumber', '<1.3.0'
  gem 'gherkin', '<2.12.0'
  gem 'rake', '< 11.0' # Rake dropped 1.8.x support after this version
elsif RUBY_VERSION =~ /^1\./
  gem 'cucumber', '<2.0.0'
end

if RUBY_VERSION =~ /^1\./
  gem 'tins', '< 1.7' # The 'tins' gem requires Ruby 2.x on/after this version
  gem 'json', '< 2.0' # The 'json' gem drops pre-Ruby 2.x support on/after this version
  gem 'term-ansicolor', '< 1.4' # The 'term-ansicolor' gem requires Ruby 2.x on/after this version
end
