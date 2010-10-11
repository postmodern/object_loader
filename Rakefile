require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/contextify/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'contextify'
  gem.version = Contextify::VERSION
  gem.license = 'MIT'
  gem.summary = %Q{Loads Ruby Objects containing methods and procs from Ruby files.}
  gem.description = %Q{Contextify can load Ruby Objects containing methods and procs from Ruby files without having to use YAML or define classes named like the file.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/postmodern/contextify'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
