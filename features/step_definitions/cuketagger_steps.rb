Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

When /^I run cuketagger with "([^\"]*)"$/ do |args|
  @stdout, @stderr = run_cuketagger args
end

Then /^I should see:$/ do |string|
  p :stderr => @stderr if $DEBUG
  @stdout.should == string
end

Then /^the content of "([^\"]*)" should be:$/ do |file_name, expected_content|
  File.read(file_name).should == expected_content
end

