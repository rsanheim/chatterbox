require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. example_helper]))
require 'chatterbox'

describe Chatterbox::EmailConsumer do

  
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

end