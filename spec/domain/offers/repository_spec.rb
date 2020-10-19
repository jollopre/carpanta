require 'domain/offers/repository'

RSpec.describe Carpanta::Domain::Offers::Repository do
  subject { described_class.new }
  describe '#save' do
    let(:offer) { FactoryBot.build(:offer) }

    it 'returns Success' do
      result = subject.save(offer)

      expect(result.success?).to eq(true)
    end

    context 'when there is an error saving the offer' do
      let(:storage) do
        Class.new do
          def initialize(*args)
          end
          def save
            false
          end
        end
      end
      subject { described_class.new(storage: storage) }

      it 'returns Failure' do
        result = subject.save(offer)

        expect(result.failure?).to eq(true)
      end
    end
  end
end
