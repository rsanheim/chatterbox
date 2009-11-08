require 'example_helper'
require 'chatterbox/exception_notification'
require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. rails init]))

describe Chatterbox::RailsCatcher do
  
  def helper
    @helper ||= Class.new {
      include Chatterbox::RailsCatcher
    }.new
  end
  
  describe "logger" do
    it "should delegate to Chatterbox#logger" do
      Chatterbox.expects(:logger)
      helper.logger
    end
  end
  
  describe "configuration" do
    after do
      Chatterbox::RailsCatcher.configure { |c| c.ignore = Chatterbox::RailsCatcher.default_ignored_exceptions }
    end

    it "ignores common Rails exceptions by default" do
      Chatterbox::RailsCatcher.configuration.ignore.should == Chatterbox::RailsCatcher.default_ignored_exceptions
    end
    
    it "allows adding exceptions to the ignore list" do
      Chatterbox::RailsCatcher.configure do |config|
        config.ignore << "SomeOtherException"
      end
      Chatterbox::RailsCatcher.configuration.ignore.should include("SomeOtherException")
    end
  end
end
