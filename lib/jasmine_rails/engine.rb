require 'rails'
require 'jasmine-core'

module JasmineRails
  class Engine < ::Rails::Engine
    isolate_namespace JasmineRails

    initializer :assets do
      [Jasmine::Core.path, JasmineRails.include_dir, JasmineRails.spec_dir, JasmineRails.support_dir].flatten.compact.each do |dir|
        Rails.application.config.assets.paths << dir
      end
      Rails.application.config.assets.precompile += %w(
        jasmine.css
        jasmine2-boot.js
        json2.js
        jasmine.js
        jasmine-html.js
        jasmine-console-shims.js
        jasmine-console-reporter.js
        jasmine-specs.js
        jasmine-specs.css
        blanket.js
        jasmine-blanket.js
      )
    end
  end
end
