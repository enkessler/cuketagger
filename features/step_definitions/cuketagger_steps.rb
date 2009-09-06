Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

When /^I run cuketagger with "([^\"]*)"$/ do |args|
  @output = run_cuketagger args
end

Then /^I should see:$/ do |string|
  @output.should == string
end

Then /^the content of "([^\"]*)" should be:$/ do |file_name, expected_content|
  File.read(file_name).should == expected_content
end

Then /^I should see '(.+?)' on stderr$/ do |str|
  @stderr.should include(str)
end
