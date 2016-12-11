Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  CukeTaggerHelper.create_file(file_name, file_content)
  (@created_files ||= []) << file_name
end

When /^I run cuketagger with "([^\"]*)"$/ do |args|
  @output = CukeTaggerHelper.run_cuketagger args
end

Then /^I should see:$/ do |string|
  expect(@output).to eq(string)
end

Then /^the content of "([^\"]*)" should be:$/ do |file_name, expected_content|
  expect(File.read(file_name)).to eq(expected_content)
end

Then /^I should see '(.+?)' in the output$/ do |str|
  expect(@output).to include(str)
end
