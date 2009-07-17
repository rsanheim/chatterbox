require File.join(File.dirname(__FILE__), *%w[example_helper])

describe QueuedExceptions do

  it "can handle" do
    exception = RuntimeError.new
    @handled = []
    QueuedExceptions.register_handler do |notice|
      @handled << notice
    end
    QueuedExceptions.handle(exception)
    @handled.size.should == 1
  end
end
