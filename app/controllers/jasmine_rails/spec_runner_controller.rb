module JasmineRails
  class SpecRunnerController < JasmineRails::ApplicationController
    begin
      helper JasmineRails::SpecHelper
    rescue
      nil
    end

    def index
      JasmineRails.reload_jasmine_config
    end
  end
end
