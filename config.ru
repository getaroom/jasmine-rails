require 'rubygems'
require 'bundler'
require 'byebug'

Bundler.require :default, :development

Combustion.initialize! :action_controller, :action_view, :sprockets do
  config.assets.compress = false
  config.assets.debug = true
  config.assets.compile = true
end

run Combustion::Application
