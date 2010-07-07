$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

begin
  require 'jeweler'
  $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),'lib'))
  require 'chatterbox/version'
  Jeweler::Tasks.new do |gem|
    gem.name = "chatterbox"
    gem.summary = %Q{Notifications and messages}
    gem.version = Chatterbox::Version::STRING
    gem.description = "Send notifications and messages.  However you want."
    gem.email = "rsanheim@gmail.com"
    gem.homepage = "http://github.com/rsanheim/chatterbox"
    gem.authors = ["Rob Sanheim"]
    gem.add_development_dependency "mocha"
    gem.add_development_dependency "actionpack"
    gem.add_development_dependency "rspec", "~> 2.0.0.beta"
    gem.add_development_dependency "rspec-rails", "~> 2.0.0.beta"
    # gem.add_development_dependency "rspec-rails23", "~> 0.1.0"
    gem.add_development_dependency "cucumber", "~> 0.7"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

if RUBY_VERSION <= "1.8.7"
  RSpec::Core::RakeTask.new(:coverage) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov_opts = %[-Ilib -Ispec --exclude "gems/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
    spec.rcov = true
  end
else
  task :coverage => :spec
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber)

  task :cucumber => :check_dependencies
rescue LoadError
  task :cucumber do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => [:check_dependencies, :coverage, :cucumber]

begin
  %w{sdoc sdoc-helpers rdiscount}.each { |name| gem name }
  require 'sdoc_helpers'
rescue LoadError => ex
  puts "sdoc support not enabled:"
  puts ex.inspect
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "chatterbox #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
