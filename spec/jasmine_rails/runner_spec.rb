require 'jasmine_rails/runner'
class Dummy
  def boot
  end
end

module JasmineRails
  RSpec.describe Runner, type: :module do
    describe '#run' do
      let(:dummy_class) { Dummy.new }

      it 'should start a server and run ' do
        expect(described_class).to receive(:server).and_return(dummy_class)
        expect(dummy_class).to receive(:boot)
        expect(described_class).to receive(:run_cmd)

        described_class.run
      end
    end
  end
end
