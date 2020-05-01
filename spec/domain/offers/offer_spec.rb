require 'domain/offers/offer'

RSpec.describe Carpanta::Domain::Offers::Offer do
  describe '.build' do
    it 'returns an offer' do
      offer = FactoryBot.build(:offer)

      expect(offer.tasks).to eq(['Cutting with scissor', 'Shampooing'])
      expect(offer.price).to eq(2200)
    end
  end

  describe 'tasks' do
    it 'needs to be present' do
      offer = FactoryBot.build(:offer, tasks: nil)

      expect(offer.errors).to include(:tasks)
      expect(offer.errors.details).to include(
        tasks: include(
          error: :blank
        )
      )
    end

    it 'needs to be an array' do
      offer = FactoryBot.build(:offer, tasks: 'foo')

      expect(offer.errors).to include(:tasks)
      expect(offer.errors.details).to include(
        tasks: include(
          error: :not_an_array,
          value: 'foo'
        )
      )
    end

    context 'when it is an array' do
      context 'but any of its objects is not string' do
        it 'returns error, value and index' do
          offer = FactoryBot.build(:offer, tasks: ['foo', nil, {}])

          expect(offer.errors).to include(:tasks)
          expect(offer.errors.details).to include(
            tasks: include(
              error: :not_a_string,
              value: nil,
              index: 1
            )
          )
          expect(offer.errors.details).to include(
            tasks: include(
              error: :not_a_string,
              value: {},
              index: 2
            )
          )
        end
      end
    end
  end

  describe 'price' do
    it 'needs to be present' do
      offer = FactoryBot.build(:offer, price: nil)

      expect(offer.errors).to include(:price)
      expect(offer.errors.details).to include(
        price: include(
          error: :blank
        )
      )
    end

    context 'numericality' do
      it 'needs to be integer' do
        offer = FactoryBot.build(:offer, price: 22.00)

        expect(offer.errors).to include(:price)
        expect(offer.errors.details).to include(
          price: include(
            error: :not_an_integer,
            value: 22.00
          )
        )
      end

      it 'needs to be positive' do
        offer = FactoryBot.build(:offer, price: -2200)

        expect(offer.errors).to include(:price)
        expect(offer.errors.details).to include(
          price: include(
            count: 0,
            error: :greater_than,
            value: -2200
          )
        )
      end

      it 'needs to be greater than zero' do
        offer = FactoryBot.build(:offer, price: 0)

        expect(offer.errors).to include(:price)
        expect(offer.errors.details).to include(
          price: include(
            count: 0,
            error: :greater_than,
            value: 0
          )
        )
      end
    end
  end

  describe '#name' do
    it 'returns a comma-separated tasks where the last element is joined by the connector and' do
      offer = FactoryBot.build(:offer)

      expect(offer.name).to eq('Cutting with scissor and Shampooing')
    end

    context 'when there is one element' do
      it 'does not add the connector' do
        offer = FactoryBot.build(:offer, tasks: ['Cutting with scissor'])

        expect(offer.name).to eq('Cutting with scissor')
      end
    end
  end

  describe '#attributes' do
    it 'returns an offer hash' do
      offer = FactoryBot.build(:offer)

      expect(offer.attributes).to include(
        tasks: ['Cutting with scissor', 'Shampooing'],
        price: 2200
      )
    end
  end

  describe '#==' do
    let(:offer) { FactoryBot.build(:offer) }

    context 'when the object passed does not respond to attributes' do
      it 'returns false' do
        another_offer = nil

        result = offer == another_offer

        expect(result).to eq(false)
      end
    end

    context 'when any of its attributes is different' do
      it 'returns false' do
        another_offer = FactoryBot.build(:offer, tasks: ['foo'])

        result = offer == another_offer

        expect(result).to eq(false)
      end
    end

    it 'returns true' do
      another_offer = FactoryBot.build(:offer)

      result = offer == another_offer

      expect(result).to eq(true)
    end
  end
end
