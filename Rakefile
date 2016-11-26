require 'racatt'


namespace 'cuketagger' do
  Racatt.create_tasks

  # The task that CI will use
  task :ci_build => [:test_everything]


  task :smart_test do |t, args|
    rspec_args = ''
    cucumber_args = '-f progress'

    Rake::Task['cuketagger:test_everything'].invoke(rspec_args, cucumber_args)
  end

end


task :default => 'cuketagger:smart_test'
