require 'racatt'


namespace 'cuketagger' do
  Racatt.create_tasks

  # The task that CI will use
  task :ci_build => [:smart_test]


  task :smart_test do |t, args|
    rspec_args = '--pattern testing/rspec/spec/**/*_spec.rb'
    cucumber_args = 'testing/cucumber/features -r testing/cucumber/features -f progress'

    Rake::Task['cuketagger:test_everything'].invoke(rspec_args, cucumber_args)
  end

end


task :default => 'cuketagger:smart_test'
