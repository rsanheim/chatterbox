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
      presenter = Chatterbox::ExceptionNotification::Presenter.new({})
      presenter.render_section("environment").should be_nil
    end
  end
  
end