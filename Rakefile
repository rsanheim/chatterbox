begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  begin
    # Fall back on doing an unlocked resolve at runtime.
    require "rubygems"
    require "bundler"
    Bundler.setup
  rescue => e
    message =<<EOM
  An error occured while trying to setup the Bundler environment:
    #{e.inspect}
    
  Chatterbox development uses bundler for managing gem dependencies.  
  Please make sure you have Bundler installed and you have installed all of
  Chatterbox's required development dependencies by running the following:

    gem install bundler
    bundle install
EOM
    abort message
  end
end

require 'rake'
require 'cucumber/rake/task'

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
    gem.add_development_dependency "micronaut"
    gem.add_development_dependency "micronaut-rails"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamplescd'
end

Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.rcov_opts = %[-Ilib -Iexamples --exclude "examples/*,gems/*,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
  examples.rcov = true
end

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = %w{--format progress}
end

if RUBY_VERSION == '1.9.1'
  task :default => [:examples, :features]
else
  task :default => [:rcov, :features]
end

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
