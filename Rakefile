unless ENV["RUN_CODE_RUN"] # WIP until RCR has Bundler support....
  begin 
    require 'vendor/gems/environment'
  rescue LoadError
    message =<<EOM
    Chatterbox development uses bundler for managing gem dependencies.  
    Please install and set-up bundler:
  
      gem install bundler
      gem bundle
      rake # you're all set!
EOM
    abort message
  end
end

require 'rake'
require 'cucumber/rake/task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chatterbox"
    gem.summary = %Q{Notifications and messages}
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
  examples.ruby_opts << '-Ilib -Iexamples'
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
