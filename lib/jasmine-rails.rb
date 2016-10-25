require 'jasmine_rails/engine'

module JasmineRails
  DEFAULT_TMP_DIR = 'tmp/jasmine/'.freeze
  CONSOLE_REPORTERS = {
    'console' => [
      'jasmine-console-shims.js',
      'jasmine-console-reporter.js'
    ]
  }.freeze

  class << self
    # return the relative path to access the spec runner
    # for the host Rails application
    # ex: /jasmine
    def route_path
      route = Rails.application.routes.named_routes[:jasmine_rails]
      raise 'JasmineRails::Engine has not been mounted. Try adding `mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)` to routes.rb' unless route
      path = route.path

      # Rails 3.1 support
      if path.is_a?(String)
        path
      else
        path.spec.to_s
      end
    end

    def src_dir
      path = jasmine_config.fetch 'src_dir', 'app/assets/javascripts'
      Rails.root.join(path)
    end

    def spec_dir
      paths = jasmine_config.fetch 'spec_dir', 'spec/javascripts'
      [paths].flatten.map { |path| Rails.root.join(path) }
    end

    def include_dir
      paths = jasmine_config.fetch 'include_dir', nil
      [paths].flatten.compact.map { |path| Rails.root.join(path) }
    end

    def tmp_dir
      path = jasmine_config.fetch 'tmp_dir', JasmineRails::DEFAULT_TMP_DIR
      Rails.root.join(path)
    end

    def support_dir
      paths = jasmine_config.fetch 'support_dir', 'support_dir'
      [paths].flatten.map { |path| Rails.root.join(path) }
    end

    def reporter_files(types_string)
      types = types_string.to_s.split(',')

      reporters = jasmine_config.fetch 'reporters', {}
      reporters = reporters.merge(JasmineRails::CONSOLE_REPORTERS)

      reporters.values_at(*types).compact.flatten
    end

    def coverage_include_filter
      jasmine_config.fetch 'include_filter', src_files
    end

    def coverage_exclude_filter
      jasmine_config.fetch 'exclude_filter', ''
    end

    # returns list of all files to be included into the jasmine testsuite
    # includes:
    # * application src_files
    # * spec helpers
    # * spec_files
    def spec_files
      files = []
      files += filter_files src_dir, jasmine_config.fetch('src_files', nil)
      spec_dir.each do |dir|
        files += filter_files dir, jasmine_config.fetch('helpers', nil)
        files += filter_files dir, jasmine_config.fetch('spec_files', nil)
      end

      # Sprockets 4 wants "logical paths" not to include file extensions
      if defined?(Sprockets) && Sprockets::VERSION.to_f >= 4
        files = files.map { |f| f.chomp File.extname(f) }
      end

      files
    end

    def src_files
      files = []
      [src_dir].compact.each do |dir|
        files += filter_files dir, jasmine_config['src_files']
      end

      files
    end

    # return a list of any additional CSS files to be included into the jasmine testsuite
    def css_files
      files = []
      files += filter_files css_dir, jasmine_config['css_files']
      spec_dir.each do |dir|
        files += filter_files dir, jasmine_config['css_files']
      end
      files
    end

    # iterate over all directories used as part of the testsuite (including subdirectories)
    def each_spec_dir(&block)
      spec_dir.each do |dir|
        each_dir dir.to_s, &block
      end
      each_dir src_dir.to_s, &block
      each_dir css_dir.to_s, &block
    end

    # clear out cached jasmine config file
    # it would be nice to automatically flush when the jasmine.yml file changes instead
    # of having this programatic API
    def reload_jasmine_config
      @config = nil
    end

    # force ssl when loading the test runner. Set to true if your app forces SSL
    def force_ssl
      jasmine_config['force_ssl'] || false
    end

    def custom_boot
      jasmine_config.fetch 'boot_script', nil
    end

    # use the phantom command from the phantom gem.
    # Set to false if you want to manage your own phantom executable
    def use_phantom_gem?
      jasmine_config['use_phantom_gem'].nil? || jasmine_config['use_phantom_gem'] == true
    end

    private

    def css_dir
      path = jasmine_config.fetch 'css_dir', 'app/assets/stylesheets'
      Rails.root.join(path)
    end

    def jasmine_config
      @config ||= begin
        path = Rails.root.join('config', 'jasmine.yml')
        path = Rails.root.join('spec', 'javascripts', 'support', 'jasmine.yml') unless File.exist?(path)
        initialize_jasmine_config_if_absent(path)
        require 'yaml'
        YAML.load_file(path)
      end
    end

    def each_dir(root, &block)
      yield root
      Dir[root + '/*'].each do |file|
        each_dir(file, &block) if File.directory?(file)
      end
    end

    def filter_files(root_dir, patterns)
      files = patterns.to_a.map do |pattern|
        Dir.glob(root_dir.join(pattern)).sort
      end
      files = files.flatten
      files = files.map { |f| f.gsub(root_dir.to_s + '/', '') }
      files || []
    end

    def initialize_jasmine_config_if_absent(path)
      return if File.exist?(path)
      Rails.logger.warn("Initializing jasmine.yml configuration")
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.cp(File.join(File.dirname(__FILE__), 'generators', 'jasmine_rails', 'templates', 'jasmine.yml'), path)
    end
  end
end
