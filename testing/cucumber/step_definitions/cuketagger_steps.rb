Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  name = File.basename(file_name, '.*')
  extension = File.extname(file_name)

  create_file(directory: @root_test_directory, name: name, extension: extension, text: file_content)
end

When /^I run cuketagger with "([^\"]*)"$/ do |args|
  args.gsub!('<path_to>', @root_test_directory)

  @output = run_cuketagger args
end

Then /^I should see:$/ do |string|
  expect(@output).to eq(string)
end

Then /^the content of "([^\"]*)" should be:$/ do |file_name, expected_content|
  expect(File.read("#{@root_test_directory}/#{file_name}")).to eq(expected_content)
end

Then /^I should see '(.+?)' in the output$/ do |str|
  expect(@output).to include(str)
end
