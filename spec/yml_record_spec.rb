class YmlExample < YmlRecord::Base
  self.filepath = 'spec/data/yml_example.yml'

  enum :job
  enum :name, singular: true

  scope :bosses, -> { where(job: %w[boss big_boss]) }
  scope :bastien, -> { where(name: 'Bastien') }
end

class OtherYmlExample < YmlRecord::Base
  self.filepath = 'spec/data/other_yml_example.yml'
end

RSpec.describe YmlExample, type: :model do
  shared_examples 'correct_results' do
    it 'returns the relation of correct instances' do
      is_expected.to be_a_kind_of(YmlRecord::Relation)
      is_expected.to match_array(expected_results) 
    end
  end

  describe 'first' do # delegates_missing_to :all -> :list
    subject { described_class.first }
    it('returns first object') { is_expected.to eq described_class.new(id: 10) }
  end

  describe 'all' do
    subject(:all) { described_class.all }

    describe 'count' do
      subject { all.count }
      it { is_expected.to eq 6 }
    end

    describe 'last' do
      subject { all.last }
      it('returns last object') { is_expected.to eq YmlExample.new(id: 60) }
    end

    describe 'first' do
      subject { all.first }
      it('returns first object') { is_expected.to eq YmlExample.new(id: 10) }
    end
  end

  describe 'where' do
    subject { described_class.where(job: job) }

    context 'when searching for attribute' do
      let(:job) { 'dev' }
      let(:expected_results) { [YmlExample.new(id: 30), YmlExample.new(id: 40), YmlExample.new(id: 50)] }

      include_examples 'correct_results'
    end

    context 'when searching for nil' do
      let(:job) { nil }
      let(:expected_results) { [YmlExample.new(id: 60)] }

      include_examples 'correct_results'
    end

    context 'when searching for list' do
      let(:job) { ['big_boss', 'boss'] }
      let(:expected_results) { [YmlExample.new(id: 10), YmlExample.new(id: 20)] }

      include_examples 'correct_results'
    end
  end

  describe 'find_by' do
    let(:opts) { { job: job } }
    subject { described_class.find_by(**opts) }

    context 'when only one instance' do
      let(:job) { 'big_boss' }

      it { is_expected.to eq YmlExample.new(id: 10) }
    end

    context 'when only more than one instance' do
      let(:job) { 'dev' }

      it { is_expected.to eq YmlExample.new(id: 30) }
    end

    context 'when only no instances' do
      let(:job) { 'CEO' }

      it { is_expected.to eq nil }
    end

    context 'when searching for attribute that is not on instance' do
      let(:opts) { { hobby: 'cricket' } }

      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end

  describe 'enum' do
    describe 'scopes' do
      context 'when calling singular getter' do
        subject { YmlExample.Bastien } 

        it 'returns an instance' do
          is_expected.to eq YmlExample.new(id: 10)
        end
      end


      context 'when calling scope that has one instance' do
        subject { YmlExample.boss }

        it 'returns a relation of correct instances' do
          is_expected.to be_a_kind_of(YmlExample::Relation)
          is_expected.to match_array([
            YmlExample.new(id: 20)
          ])
        end
      end

      context 'when calling scope that has many instances' do
        subject { YmlExample.dev }

        it 'returns a relation of correct instances' do
          is_expected.to be_a_kind_of(YmlExample::Relation)
          is_expected.to match_array([
            YmlExample.new(id: 30),
            YmlExample.new(id: 40),
            YmlExample.new(id: 50)
          ])
        end
      end

      context 'when calling scope that has no instances' do
        subject { YmlExample.foobar }

        it { expect { subject }.to raise_error(NoMethodError) }
      end
    end

    describe 'checker' do
      subject { instance.dev? }

      context 'when checker is true' do
        let(:instance) { described_class.find_by(job: 'dev') }
        it { is_expected.to be true }
      end

      context 'when checker is false' do
        let(:instance) { described_class.find_by(job: 'big_boss') }
        it { is_expected.to be false }
      end

      context 'when checking non-value' do
        subject { instance.cricket? }
        let(:instance) { described_class.find_by(job: 'big_boss') }

        it 'raises an error' do
          expect { subject }.to raise_error(NoMethodError)
        end
      end
    end

    describe 'list' do
      subject { described_class.jobs }

      it { is_expected.to eq ['big_boss', 'boss', 'dev'] }
    end
  end

  describe 'scope' do
    context 'when calling single' do
      subject { described_class.bosses }
      let(:expected_results) { [YmlExample.new(id: 10), YmlExample.new(id: 20)] }

      include_examples 'correct_results'
    end

    context 'when chaining' do
      subject { described_class.bosses.bastien }
      let(:expected_results) { [YmlExample.new(id: 10)] }

      include_examples 'correct_results'
    end
  end

  describe 'attributes' do
    let(:instance) { described_class.first }

    context 'when querying attribute that exists' do
      subject { instance.name }

      it { is_expected.to eq 'Bastien' }
    end

    context 'when querying attribute that does not exists' do
      subject { instance.hobby }

      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end

  describe '.abstract_class' do
    # class with no corresponding yml file
    class AbstractClass < YmlRecord::Base
      self.abstract_class = true
    end

    class Inheritor < AbstractClass
      self.filepath = 'spec/data/yml_example.yml'
    end

    it 'registers abstract_class and does not require yml file, does not require inheritor to reset abstract class' do
      expect(AbstractClass.first).to eq nil
      expect(AbstractClass.abstract_class).to eq true
      expect(Inheritor.last.id).to eq YmlExample.last.id
      expect(Inheritor.abstract_class).to eq nil
    end
  end
end

RSpec.describe 'yaml model memory usage', type: :model do
  describe 'all' do
    it 'only parses from each yaml file once' do

      # needed to clear out instance vairables set in other tests
      # needs to ensure all is set, and then clear it.
      # so data usage can be tracked
      YmlExample.all
      OtherYmlExample.all
      YmlExample.remove_instance_variable(:@all)
      OtherYmlExample.remove_instance_variable(:@all)

      expect(YmlExample).to receive(:data).once.and_call_original
      expect(OtherYmlExample).to receive(:data).once.and_call_original

      expect(YmlExample.all.count).to eq 6
      expect(YmlExample.all.count).to eq 6
      expect(OtherYmlExample.all.count).to eq 2
      expect(OtherYmlExample.all.count).to eq 2
    end
  end
end

