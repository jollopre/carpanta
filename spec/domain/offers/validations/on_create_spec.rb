require 'domain/offers/validations/on_create'
require 'spec/domain/shared/shared_examples'

RSpec.describe Carpanta::Domain::Offers::Validations::OnCreate do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        price: 2200,
        tasks: ['Cutting with scissor', 'Shampooing']
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'price' do
        it_behaves_like 'must be an integer', { price: 'foo' }, :price

        it 'must be greater than zero' do
          result = subject.call(default_params.merge(price: 0))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            price: include('must be greater than 0')
          )
        end
      end

      context 'tasks' do
        it_behaves_like 'must be an array', { tasks: {} }, :tasks

        it 'each element must be a string' do
          result = subject.call(default_params.merge(tasks: [{}, false]))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            tasks: include(
              0 => include('must be a string'),
              1 => include('must be a string')
            )
          )
        end
      end
    end
  end
end
