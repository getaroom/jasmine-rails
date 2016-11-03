module JasmineRails
  class DummyClass < ApplicationController
    include ::ActionView::Helpers
    include SpecRunnerHelper
  end

  RSpec.describe SpecRunnerHelper, type: :helper do
    let(:jasmine_config) { {} }
    before do
      allow(JasmineRails).to receive(:jasmine_config).and_return(jasmine_config)
    end

    describe '#jasmine_css_files' do
      subject { DummyClass.new.jasmine_css_files }

      it { is_expected.to be_a(Array) }
      it { is_expected.to include(/jasmine\.css/) }
      it { is_expected.to include(/jasmine-specs\.css/) }
    end

    describe '#jasmine_js_files' do
      before do
        allow(class_object).to receive(:params).and_return(reporters: 'console')
      end
      let(:class_object) { DummyClass.new }

      subject { class_object.jasmine_js_files }

      it { is_expected.to be_a(Array) }
      it { is_expected.to include(/jasmine\.js/) }
      it { is_expected.to include(/json2\.js/) }
      it { is_expected.to include(/jasmine-console-shims\.js/) }
      it { is_expected.to include(/jasmine-console-reporter\.js/) }
    end

    describe '#jasmine_boot_file' do
      let(:class_object) { DummyClass.new }
      subject { class_object.jasmine_boot_file }

      it { is_expected.to match(/boot\.js/) }

      context 'custom boot file' do
        let(:jasmine_config) { { 'boot_script' => 'spec/js/jasmine_boot.js' } }
        it { is_expected.to match(%r{spec\/js\/jasmine_boot\.js}) }
      end
    end

    describe '#coverage_include_filter' do
      let(:src_files) { ['application.js'] }
      let(:jasmine_config) { { 'src_files' => src_files } }
      subject { DummyClass.new.coverage_include_filter }

      it { is_expected.to be_a(String) }
      it { is_expected.to match("/application(.*).js") }
    end

    describe '#blanket_js_options' do
      let(:jasmine_config) { { 'include_filter' => '//.*/app/.*/' } }
      subject { DummyClass.new.blanket_js_options }

      it { is_expected.to be_a(Hash) }
      it { is_expected.to have_key(:'data-cover-adapter') }
      it { is_expected.to have_key(:'data-cover-only') }
      it { is_expected.to include(:'data-cover-only' => '//.*/app/.*/') }

      context 'with exclude filter' do
        let(:jasmine_config) { { 'include_filter' => '//.*/app/.*/', 'exclude_filter' => '/application.js/' } }
        it { is_expected.to be_a(Hash) }
        it { is_expected.to have_key(:'data-cover-adapter') }
        it { is_expected.to have_key(:'data-cover-only') }
        it { is_expected.to have_key(:'data-cover-never') }
        it { is_expected.to include(:'data-cover-never' => '/application.js/') }
      end
    end
  end
end
