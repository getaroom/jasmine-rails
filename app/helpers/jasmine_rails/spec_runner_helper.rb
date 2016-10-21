require 'jasmine-core'

module JasmineRails
  module SpecRunnerHelper
    # return list of css files to include in spec runner
    # all files are fetched through the Rails asset pipeline
    # includes:
    # * core jasmine css files
    def jasmine_css_files
      files = Jasmine::Core.css_files
      files << 'jasmine-specs.css'
      files
    end

    # return list of javascript files needed for jasmine testsuite
    # all files are fetched through the Rails asset pipeline
    # includes:
    # * core jasmine libraries
    # * (optional) reporter libraries
    # * jasmine-boot.js test runner
    # * jasmine-specs.js built by asset pipeline which merges application specific libraries and specs
    def jasmine_js_files
      files = Jasmine::Core.js_files
      files << jasmine_boot_file
      files += JasmineRails.reporter_files params[:reporters]
      files << 'jasmine-specs.js' unless requirejs_spec_loading?
      files
    end

    def src_files
      JasmineRails.src_files
    end

    def jasmine_spec_files
      JasmineRails.spec_files
    end

    def jasmine_boot_file
      if JasmineRails.custom_boot
        JasmineRails.custom_boot
      else
        'jasmine2-boot.js'
      end
    end

    def requirejs_spec_loading?
      defined?(Requirejs) ? true : false
    end

    def coverage_exclude_filter
      JasmineRails.coverage_exclude_filter
    end

    def coverage_include_filter
      if JasmineRails.coverage_include_filter.is_a?(Array)
        safe_join(JasmineRails.coverage_include_filter.map do |src_file|
          "/#{javascript_path(src_file).gsub(/-[a-z0-9]{64}\.js/, '(.*)?.js')}/"
        end).tr('"', "'")
      else
        JasmineRails.coverage_include_filter
      end
    end

    def blanket_js_options
      options = {
        :'data-cover-adapter' => javascript_path('jasmine-blanket.js')
      }

      options[:'data-cover-only']  = coverage_include_filter unless coverage_include_filter.empty?
      options[:'data-cover-never'] = coverage_exclude_filter unless coverage_exclude_filter.empty?

      options
    end
  end
end
