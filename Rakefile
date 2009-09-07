require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chatterbox"
    gem.summary = %Q{TODO}
    gem.email = "rsanheim@gmail.com"
    gem.homepage = "http://github.com/relevance/chatterbox"
    gem.authors = ["Rob Sanheim"]
    gem.add_development_dependency "mocha"
    gem.add_development_dependency "actioncontroller"
    gem.add_development_dependency "spicycode-micronaut"
    gem.add_development_dependency "spicycode-micronaut-rails"
  end

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
  examples.rcov_opts = '-Ilib -Iexamples'
  examples.rcov = true
end


task :default => :examples