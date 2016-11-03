require 'rake'
require 'combustion'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'jasmine-rails'

Combustion.initialize! :action_controller, :action_view, :sprockets do
  config.assets.compress = false
  config.assets.debug = true
  config.assets.compile = true
end

Capybara.app = Combustion::Application
Capybara.save_path = 'tmp/capybara'
Capybara.default_selector = :css
Capybara.default_max_wait_time = 2

Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: true,
    timeout: 360,
    debug: false,
    phantomjs_options: ['--load-images=yes', '--disk-cache=false'],
    inspector: true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.default_driver = :poltergeist

World(Capybara::RSpecMatchers)
World(Capybara::DSL)
World { Capybara.app.routes.url_helpers }
