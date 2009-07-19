require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. example_helper]))
require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. rails init]))

ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action/:id' }

class WidgetException < RuntimeError; end
class WidgetsController < ActionController::Base
  include Chatterbox::RailsCatcher

  def rescue_action e
    rescue_action_in_public e
  end
  
  def rescue_action_in_public_without_chatterbox e
    raise e
  end
  
  def index
    raise_exception
    render :text => "hi"
  end
  
  def raise_exception
    raise WidgetException, "Bad dog!"
  end
end

describe WidgetsController do
  
  describe "rescue aliasing" do
    
    it "should alias method chain" do
      exception = RuntimeError.new
      @controller.expects(:rescue_action_in_public_without_chatterbox).with(exception)
      @controller.rescue_action_in_public(exception)
    end
  end

  describe "exception handling" do
    
    it "should raise on index" do
      lambda {
        get :index
      }.should raise_error(WidgetException, "Bad dog!")
    end
    
    it "should send exception to handle_notice" do
      Chatterbox.expects(:handle_notice).with(instance_of(WidgetException))
      get :index rescue nil
    end
    
  end

end
