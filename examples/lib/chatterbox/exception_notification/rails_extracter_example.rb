require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::RailsExtracter do

  describe "wrap" do
    describe "when Rails is not defined or not found" do
      it "returns message unchanged" do
        Object.expects(:const_defined?).with("Rails").returns(false)
        original_hash = {:foo => "bar", :something => "else"}
        hsh = Chatterbox::ExceptionNotification::RailsExtracter.wrap(original_hash)
        hsh.should == original_hash
      end
    end
    
    describe "when Rails is defined" do
      it "merges in rails root, env, and version" do
        rails = stub_everything({
          :env => "production",
          :root => "/a/blah/current",
          :version => "2.3.2"
        })
        Chatterbox::ExceptionNotification::RailsExtracter.any_instance.stubs(:rails_configuration).returns(rails)
        details = Chatterbox::ExceptionNotification::RailsExtracter.wrap({})
        details[:rails_info][:rails_root].should == "/a/blah/current"
        details[:rails_info][:rails_env].should == "production"
        details[:rails_info][:rails_version].should == "2.3.2"
      end
    end
  end
  
  describe "rails_configuration" do
    it "returns top level Rails config if defined" do
      Object.expects(:const_defined?).with("Rails").returns(true)
      Object.expects(:const_get).with("Rails").returns("fake rails const")
      filter = Chatterbox::ExceptionNotification::RailsExtracter.new
      filter.rails_configuration.should == "fake rails const"
    end
  end

end