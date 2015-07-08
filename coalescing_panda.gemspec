$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "coalescing_panda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "coalescing_panda"
  s.version     = CoalescingPanda::VERSION
  s.authors     = ["Nathan Mills", "Cody Tanner", "Jake Sorce"]
  s.email       = ["nathanm@instructure.com", "ctanner@instructure.com", "jake@instructure.com"]
  s.homepage    = "http://www.instructure.com"
  s.summary     = "Canvas LTI and OAUTH2 mountable engine"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "bearcat", "1.0.21"
  s.add_dependency "macaddr", "1.6.1"
  s.add_dependency "ims-lti"
  s.add_dependency "haml-rails"
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency "jquery-rails"
  s.add_dependency "coffee-rails"
  s.add_dependency 'p3p'
  s.add_dependency 'useragent'
  s.add_dependency 'delayed_job_active_record'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "byebug"
  s.add_development_dependency "pry"
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'lol_dba'
end
