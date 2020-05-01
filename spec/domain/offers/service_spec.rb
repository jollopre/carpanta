require 'domain/offers/service'
require 'domain/offers/errors'
require 'domain/offers/repository'

RSpec.describe Carpanta::Domain::Offers::Service do
  let(:invalid_class) do
    Carpanta::Domain::Offers::Errors::Invalid
  end
  let(:repository_class) do
    class_double(Carpanta::Domain::Offers::Repository).as_stubbed_const
  end
  let(:default_attributes) do
    FactoryBot.attributes_for(:offer)
  end
  let(:offer) do
    FactoryBot.build(:offer, default_attributes)
  end

  describe '.create!' do
    context 'when there are errors' do
      context 'validating the domain instance' do
        let(:attributes) do
          default_attributes.merge(price: 'foo')
        end

        it 'raises Invalid' do
          expect do
            described_class.create!(attributes)
          end.to raise_error(invalid_class)
        end
      end
    end

    it 'creates an offer' do
      allow(repository_class).to receive(:create!)

      described_class.create!(default_attributes)

      expect(repository_class).to have_received(:create!).with(offer)
    end
  end

  describe '.find_by_id!' do
    it 'forwards into its repository' do
      allow(repository_class).to receive(:find_by_id!)

      described_class.find_by_id!('an_id')

      expect(repository_class).to have_received(:find_by_id!).with('an_id')
    end
  end
end
