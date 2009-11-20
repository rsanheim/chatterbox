Given %r{^a file named "([^"]+)" with:$} do |file_name, code|
  create_file(file_name, code)
end

When /^I run "([^\"]*)"$/ do |command|
  ruby command
end

Then /^the exit code should be (\d+)$/ do |exit_code|
  if last_exit_code != exit_code.to_i
    raise "Did not exit with #{exit_code}, but with #{last_exit_code}. Standard error:\n#{last_stderr}"
  end
end
