require_relative '../../lib/fuzzy_classname/reader'

RSpec.describe FuzzyClassname::Reader do
  let(:reader) { described_class.new(filename) }

  describe '#klasses' do
    context 'with wrong filename' do
      let(:filename) { 'data/wrong.txt' }

      it 'should raise an exception' do
        expect { reader.klasses }.to raise_exception(ArgumentError)
      end
    end

    context 'with correct filename' do
      let(:filename) { 'data/classes.txt' }

      it 'should read content successfully' do
        expect(reader.klasses).not_to be_empty
        expect(reader.klasses).to be_a(Array)
      end
    end
  end
end
