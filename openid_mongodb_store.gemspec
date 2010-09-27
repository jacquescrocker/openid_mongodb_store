# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{openid_mongodb_store}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Schenkman-Moore"]
  s.date = %q{2010-09-27}
  s.description = %q{Like the ActiveRecord Store, but for Mongo.}
  s.email = %q{samsm@samsm.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "config.ru",
     "lib/openid_mongodb_store.rb",
     "lib/openid_mongodb_store/store.rb",
     "openid_mongodb_store.gemspec",
     "test/helper.rb",
     "test/test_openid_mongodb_store.rb"
  ]
  s.homepage = %q{http://github.com/samsm/openid_mongodb_store}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An adaptor for storing OpenID nonces and associations with Mongo. Uses 10gen's Mongo Ruby library so should work with MongoMapper, Mongoid, and others.}
  s.test_files = [
    "test/helper.rb",
     "test/test_openid_mongodb_store.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<mongo>, [">= 1.0.3"])
    else
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 1.0.3"])
    end
  else
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 1.0.3"])
  end
end

