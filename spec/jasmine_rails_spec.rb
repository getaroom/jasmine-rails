RSpec.describe JasmineRails, type: :module do
  let(:jasmine_config) { {} }

  before do
    allow(described_class)
      .to receive(:jasmine_config).and_return(jasmine_config)
  end

  describe '#route_path' do
    subject { described_class.route_path }

    it 'should not raise error for no route' do
      expect { subject }
        .not_to raise_error
    end

    it 'should return path as a string' do
      is_expected.to be_a(String)
    end

    context 'without routing' do
      before do
        Rails.application.routes.draw do
        end
      end

      it 'should raise error for no route' do
        expect { subject }
          .to raise_error(/JasmineRails::Engine has not been mounted/)
      end
    end
  end

  describe '#spec_dir' do
    subject { described_class.spec_dir }
    it { is_expected.to be_a(Array) }

    it 'should default to the "spec/javascript" path' do
      expect(subject.first.to_s).to match(%r{spec\/javascript})
    end

    context 'with custom configuration' do
      let(:jasmine_config) { { 'spec_dir' => 'spec/js' } }
      it 'should use custom path' do
        expect(subject.first.to_s).to match(%r{spec\/js})
      end
    end
  end

  describe '#include_dir' do
    subject { described_class.include_dir }
    it { is_expected.to be_a(Array) }

    it 'should default to an empty array' do
      expect(subject).to be_empty
    end

    context 'with custom configuration' do
      let(:jasmine_config) { { 'include_dir' => 'spec/include' } }
      it 'should use custom path' do
        expect(subject.first.to_s).to match(%r{spec\/include})
      end
    end
  end

  describe '#tmp_dir' do
    subject { described_class.tmp_dir.to_s }
    it 'should default to "tmp/jasmine"' do
      is_expected.to match(%r{tmp\/jasmine})
    end
    context 'with custom configuration' do
      let(:jasmine_config) { { 'tmp_dir' => 'tmp/custom' } }

      it 'should use custom path' do
        is_expected.to match(%r{tmp\/custom})
      end
    end
  end

  describe '#support_dir' do
    subject { described_class.support_dir }
    it { is_expected.to be_a(Array) }

    it 'should default to the "support_dir" path' do
      expect(subject.first.to_s).to match(/support_dir/)
    end

    context 'with custom configuration' do
      let(:jasmine_config) { { 'support_dir' => 'spec/js/support' } }
      it 'should use custom path' do
        expect(subject.first.to_s).to match(%r{spec\/js\/support})
      end
    end
  end

  describe '#reporter_files' do
    let(:reporters) { '' }
    subject { described_class.reporter_files(reporters) }

    it { is_expected.to be_a(Array) }
    it { is_expected.to be_empty }

    context 'with console reporters' do
      let(:reporters) { 'console' }
      it { is_expected.to be_a(Array) }
      it { is_expected.to contain_exactly('jasmine-console-shims.js', 'jasmine-console-reporter.js') }
    end

    context 'with custom reporters' do
      let(:jasmine_config) { { 'reporters' => { 'blanket' => ['blanket.js'] } } }
      let(:reporters) { 'blanket' }
      it { is_expected.to be_a(Array) }
      it { is_expected.to contain_exactly('blanket.js') }
    end

    context 'multiple reporters' do
      let(:jasmine_config) { { 'reporters' => { 'blanket' => ['blanket.js'] } } }
      let(:reporters) { 'console,blanket' }
      it { is_expected.to be_a(Array) }
      it 'should contain console and custom reporters' do
        is_expected
          .to contain_exactly(
            'jasmine-console-shims.js',
            'jasmine-console-reporter.js',
            'blanket.js'
          )
      end
    end
  end

  describe '#coverage_include_filter' do
    subject { described_class.coverage_include_filter }

    it { is_expected.to be_a(Array) }
    it { is_expected.to be_empty }

    context 'with custom configuration' do
      let(:jasmine_config) { { 'include_filter' => '//application/.*/' } }
      it { is_expected.to be_a(String) }
      it { is_expected.to eql('//application/.*/') }
    end

    context 'with source files' do
      let(:src_files) { ['application.js'] }
      let(:jasmine_config) { { 'src_files' => src_files } }
      it { is_expected.to be_a(Array) }
      it { is_expected.to contain_exactly(*src_files) }
    end
  end

  describe '#coverage_exclude_filter' do
    subject { described_class.coverage_exclude_filter }

    it { is_expected.to be_a(String) }
    it { is_expected.to be_empty }

    context 'with custom configuration' do
      let(:jasmine_config) { { 'exclude_filter' => '//.*/' } }
      it { is_expected.to be_a(String) }
      it { is_expected.to eql('//.*/') }
    end
  end
end
