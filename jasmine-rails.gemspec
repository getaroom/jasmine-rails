$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jasmine_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jasmine-rails"
  s.version     = JasmineRails::VERSION
  s.authors     = ["Justin Searls", "Mark Van Holstyn", "Cory Flanigan"]
  s.email       = ["searls@gmail.com", "mvanholstyn@gmail.com", "seeflanigan@gmail.com"]
  s.homepage    = "http://github.com/searls/jasmine-rails"
  s.summary     = "Makes Jasmine easier on Rails 3.1"
  s.description = "Provides a Jasmine Spec Runner that plays nicely with Rails 3.1 assets and sets up jasmine-headless-webkit"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency 'railties', '>= 3.0.0'
  s.add_runtime_dependency 'sprockets-rails'
  s.add_runtime_dependency 'jasmine-core', ['>= 2.0', '< 3.0']
  s.add_runtime_dependency 'phantomjs'
  s.add_runtime_dependency 'capybara'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'cucumber', ['>= 1.3', '< 2.0.0']
  s.add_development_dependency 'mime-types', ['>= 1.16', '< 3.0']
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'combustion', '~> 0.5.5'
  s.add_development_dependency 'rubocop', '~> 0.41.0'
end
