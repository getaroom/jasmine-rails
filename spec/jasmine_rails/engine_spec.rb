module JasmineRails
  RSpec.describe Engine, type: :class do
    let(:jasmine_config) do
      {
        'spec_dir' => 'spec/js',
        'include_dir' => 'spec/include',
        'support_dir' => 'spec/js/support'
      }
    end

    before do
      allow(JasmineRails)
        .to receive(:jasmine_config).and_return(jasmine_config)

      Rails.application.config.assets.paths = []
      described_class.initializers.first.run(Rails.application)
    end

    subject { Rails.application.config.assets.paths.map(&:to_s) }

    it { is_expected.to include(/jasmine-core/) }
    it { is_expected.to include(%r{spec\/js}) }
    it { is_expected.to include(%r{spec\/include}) }
    it { is_expected.to include(%r{spec\/js\/support}) }
  end
end
