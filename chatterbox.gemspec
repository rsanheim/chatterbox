# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chatterbox}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim"]
  s.date = %q{2009-08-14}
  s.email = %q{rsanheim@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     ".treasure_map.rb",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "chatterbox.gemspec",
     "examples/chatterbox_example.rb",
     "examples/example_helper.rb",
     "examples/lib/chatterbox/consumers/email_consumer_example.rb",
     "examples/lib/chatterbox/notification_example.rb",
     "examples/lib/chatterbox/rails_catcher_example.rb",
     "init.rb",
     "lib/chatterbox.rb",
     "lib/chatterbox/notification.rb",
     "lib/chatterbox/rails_catcher.rb",
     "lib/consumers.rb",
     "lib/consumers/email_consumer.rb",
     "rails/init.rb",
     "todo.markdown",
     "version.yml",
     "views/chatterbox/mailer/exception_notification.erb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/relevance/chatterbox}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{TODO}
  s.test_files = [
    "examples/chatterbox_example.rb",
     "examples/example_helper.rb",
     "examples/lib/chatterbox/consumers/email_consumer_example.rb",
     "examples/lib/chatterbox/notification_example.rb",
     "examples/lib/chatterbox/rails_catcher_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
