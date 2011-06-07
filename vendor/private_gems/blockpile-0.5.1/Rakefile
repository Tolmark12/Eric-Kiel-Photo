require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the blockpile plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the blockpile plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Blockpile'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "blockpile"
    gemspec.summary = "piles of extendable rails view blocks, triggered and masked behind simple helpers"
    gemspec.description = "This module attempts to create structured view helpers. Essentially, a blockpile consists of a ruby class file, and a template. This allows for isolated blocks of view logic, that can maintain a clean separation of markup language from ruby code. Blocks can be inherited from to DRY up view logic."
    gemspec.email = "tylerflint@gmail.com"
    gemspec.homepage = "http://github.com/tylerflint/blockpile"
    gemspec.authors = ["Tyler Flint"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

