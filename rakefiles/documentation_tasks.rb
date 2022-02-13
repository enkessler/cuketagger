namespace 'cuketagger' do

  desc 'Check documentation with YARD'
  task :check_documentation do
    puts Rainbow('Checking inline code documentation...').cyan

    output = `yard stats --list-undoc`
    puts output

    # YARD does not do exit codes, so we have to check the output ourselves.
    raise Rainbow('Parts of the gem are undocumented').red unless output =~ /100.00% documented/

    puts Rainbow('All code documented').green
  end

end
