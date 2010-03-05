Then /^the stdout should contain the Chatterbox version string message$/ do
  version = Chatterbox::Version::STRING
  Then %{the stdout should match "Chatterbox Version #{version}"}
end
