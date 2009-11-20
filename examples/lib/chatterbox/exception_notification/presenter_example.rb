require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::Presenter  do

  describe "body" do
    it "should render sections in order" do
      options = {
        :request => {
          :parameters => {
            :remote_ip => "10.0.0.1",
            :array => [1,2,3]
          }
        },
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
ActionView::MissingTemplate: Missing template projects/show.erb in view path app/views

Request
----------
parameters: {"remote_ip"=>"10.0.0.1", "array"=>[1, 2, 3]}

Environment
----------
PATH: "/usr/bin"

Ruby Info
----------
ruby_platform: "darwin"
ruby_version: "1.8.6"
EOL
      presenter.render_body.strip.should == expected.strip
    end
    
    it "renders 'extra' sections before explicitly named, ordered sections" do
      options = {
        :environment => { "PATH" => "/usr/bin" },
        :special_details => "alert! system compromised in sector 8!"
      }
      presenter = Chatterbox::ExceptionNotification::Presenter.new(options)
      expected =<<EOL
Special Details
----------
alert! system compromised in sector 8!

Environment
----------
PATH: "/usr/bin"
EOL
      presenter.render_body.strip.should == expected.strip
    end
    
    it "renders unordered sections" do
      options = {:error_message => "Runtime error has occured", :details => "values and things"}
      presenter = Chatterbox::ExceptionNotification::Presenter.new(options)
      expected =<<EOL
Details
----------
values and things
EOL
      presenter.render_body.should include(expected)
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
  
  describe "render_hash" do
    it "outputs hashes in key sorted order" do
      hash = { 
        "my-key" => "something", 
        "zephyr" => "something",
        :nanite => "something",
        "abcdefg" => "foo"
      }
      presenter = Chatterbox::ExceptionNotification::Presenter.new
      expected =<<-EOL
abcdefg: "foo"
my-key: "something"
nanite: "something"
zephyr: "something"
EOL
      presenter.render_hash(hash).should == expected
    end
  end
end