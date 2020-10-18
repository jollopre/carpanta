require 'domain/appointments/repository'

RSpec.describe Carpanta::Domain::Appointments::Repository do
  subject { described_class.new }

  describe '#save' do
    let(:appointment) { FactoryBot.build(:appointment) }

    it 'returns Success' do
      result = subject.save(appointment)

      expect(result.success?).to eq(true)
    end

    context 'when there is an error saving the customer' do
      let(:storage) do
        Class.new do
          def initialize(*args) ; end
          def save ; false ; end
        end
      end
      subject { described_class.new(storage: storage) }

      it 'returns Failure' do
        result = subject.save(appointment)

        expect(result.failure?).to eq(true)
      end
    end
  end
end
