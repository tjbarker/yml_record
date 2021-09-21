RSpec.describe YmlRecord::Attributes do
  describe 'returns value that was passed in' do
    let(:inst) { described_class.new(attribute: 'value') }

    it { expect(inst.attribute).to eq 'value' }
  end

  describe 'returns for boolean column' do
    let(:inst) { described_class.new(attribute: true) }

    it { expect(inst.attribute?).to eq true }
  end
end
