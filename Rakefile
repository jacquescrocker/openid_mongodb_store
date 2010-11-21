require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "openid_mongodb_store"
    gem.summary = "An adaptor for storing OpenID nonces and associations with Mongo. Uses 10gen's Mongo Ruby library so should work with MongoMapper, Mongoid, and others."
    gem.description = "Like the ActiveRecord Store, but for Mongo."
    gem.email = "samsm@samsm.com"
    gem.homepage = "http://github.com/samsm/openid_mongodb_store"
    gem.authors = ["Sam Schenkman-Moore"]
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "mongo", ">= 1.0.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
