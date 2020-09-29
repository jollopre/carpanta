require 'domain/shared/identifiable'

RSpec.describe Domain::Shared::Identifiable do
  let(:klass) do
    Class.new do
      include Domain::Shared::Identifiable

      def initialize(id: nil)
        @id = id
      end
    end
  end
  
  subject { klass.new }

  describe '#id' do
    it 'returns an universaly unique identifier' do
      result = subject.id

      expect(result).to match(/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/)
    end

    context 'when the including class has id set' do
      let(:id) { 'adb65c7c-b55b-4de3-89d7-d36c438ecbad' }
      subject { klass.new(id: id) }

      it 'returns the id set' do
        result = subject.id

        expect(result).to eq(id)
      end
    end
  end

  describe '#==' do
    let(:id) { 'adb65c7c-b55b-4de3-89d7-d36c438ecbad' }
    subject { klass.new(id: id) }

    context 'when ids are the same' do
      let(:other) { double(:identifiable, id: id) }

      it 'returns true' do
        expect(subject).to eq(other)
      end
    end

    context 'when ids are different' do
      let(:other) { double(:identifiable, id: 'wadus') }

      it 'returns false' do
        expect(subject).not_to eq(other)
      end
    end

    context 'when other object does not respond to id' do
      let(:other) { double(:identifiable) }

      it 'returns false' do
        expect(subject).not_to eq(other)
      end
    end
  end
end
