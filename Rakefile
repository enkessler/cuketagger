require 'racatt'


namespace 'cuketagger' do
  Racatt.create_tasks

  # The task that CI will use
  task :ci_build => [:test_everything]
end


task :default => 'cuketagger:test_everything'
