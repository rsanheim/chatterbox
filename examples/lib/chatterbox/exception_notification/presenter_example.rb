require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::Presenter  do

  describe "body" do
    it "should render sections in order" do
      options = {
        :environment => { "PATH" => "/usr/bin" },
        :error_message => "ActionView::MissingTemplate: Missing template projects/show.erb in view path app/views",
        :ruby_info => {
          :ruby_version => "1.8.6",
          :ruby_platform => "darwin"
        }
      }
      presenter = Chatterbox::ExceptionNotification::Presenter.new(options)
      expected =<<EOL
Error Message
----------
"ActionView::MissingTemplate: Missing template projects/show.erb in view path app/views"

Environment
----------
PATH: /usr/bin

Ruby Info
----------
:ruby_version: 1.8.6
:ruby_platform: darwin
EOL
      presenter.body.strip.should == expected.strip
    end
  end
  
  describe "render_section" do
    it "should humanzie the title of the section" do
     presenter = Chatterbox::ExceptionNotification::Presenter.new({"environment" => "foo'"})
     presenter.render_section("environment").should include("Environment\n")
    end
    
    it "should inspect the value for the key" do
      presenter = Chatterbox::ExceptionNotification::Presenter.new({"environment" => "foo"})
      presenter.render_section("environment").should include(%[foo])
    end
    
    it "should return nil if the key does not exist in the options" do
      presenter = Chatterbox::ExceptionNotification::Presenter.new
      presenter.render_section("environment").should be_nil
    end
  end
  
  describe "prettyify_output" do
    it "should strip leading --- from to_yaml and retrun pretty output for hashes" do
      hash = { "my-key" => "some string value", "my-other-key" => "something" }
      presenter = Chatterbox::ExceptionNotification::Presenter.new
      output = presenter.inspect_value(hash)
      # NOTE: Handling different hash order below, between 1.8.x and 1.9.1
      actual_lines = output.split("\n")
      expected_lines = ["my-key: some string value", "my-other-key: something"]
      expected_lines.each { |line| actual_lines.should include(line) }
    end
    
    it "should strip leading --- from strings" do
      presenter = Chatterbox::ExceptionNotification::Presenter.new
      output = presenter.inspect_value("just a simple string")
      output.should == "just a simple string"
    end
  end
  
end