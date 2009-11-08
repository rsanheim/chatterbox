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
end
