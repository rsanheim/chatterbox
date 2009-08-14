require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. example_helper]))
require 'chatterbox'

describe Chatterbox::Mailer do
  
  it "displays environment vars sorted" do
    data = {
      :environment => {
        "PATH" => "/usr/bin",
        "PS1" => "$",
        "TMPDIR" => "/tmp"
      }
    }
    expected = <<EOL
PATH => /usr/bin
PS1 => $
TMPDIR => /tmp
EOL
    mail = Chatterbox::Mailer.create_exception_notification(data)
    mail.body.should include(expected.strip)
  end

  it "does not mutate the provided hash" do
    input = {'foo' => 'bar', :environment => {}}
    Chatterbox::Mailer.create_exception_notification(input)
    input.should == {'foo' => 'bar', :environment => {}}
  end

  describe "subject" do
    
    it "extracts the subject from the given data hash when the key is a symbol" do
      mail = Chatterbox::Mailer.create_exception_notification(:environment => {}, :summary => 'foo')
      mail.subject.should include('foo')
    end

    it "extracts the subject from the given data hash when the key is a string" do
      mail = Chatterbox::Mailer.create_exception_notification(:environment => {}, 'summary' => 'foo')
      mail.subject.should include('foo')
    end
    
    it "includes the given prefix" do
      Chatterbox::Mailer.email_prefix = '[super important email]'
      mail = Chatterbox::Mailer.create_exception_notification(:environment => {})
      mail.subject.should match(/\[super important email\]/)
    end
    
  end

end
