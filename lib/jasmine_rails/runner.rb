# rubocop:disable Rails/Output
module JasmineRails
  module Runner
    class << self
      # Run the Jasmine testsuite via phantomjs CLI
      # raises an exception if any errors are encountered while running the testsuite
      def run(spec_filter=nil, reporters='console')
        require 'phantomjs' if JasmineRails.use_phantom_gem?
        require 'fileutils'
        phantomjs_runner_path = File.join(File.dirname(__FILE__), '..', 'assets', 'javascripts', 'jasmine-runner.js')
        phantomjs_cmd = JasmineRails.use_phantom_gem? ? Phantomjs.path : 'phantomjs'

        server.tap do |server|
          server.boot
          run_cmd %{"#{phantomjs_cmd}" "#{phantomjs_runner_path}" "http://127.0.0.1:3000/specs?reporters=#{reporters}&spec=#{spec_filter}"}
        end
      end

      private

      def server
        require 'capybara'
        ::Capybara::Server.new(Rails.application, 3000, '0.0.0.0')
      end

      def run_cmd(cmd)
        puts "Running `#{cmd}`"
        raise "Error executing command: #{cmd}" unless system(cmd)
      end
    end
  end
end
