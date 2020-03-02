require 'app/repositories/customer'
require 'app/entities/customer'
require_relative 'shared_examples'

RSpec.describe Carpanta::Repositories::Customer do
  describe '.create!' do
    let(:entity) do
      FactoryBot.build(:customer)
    end
    let(:entity_class) do
      Carpanta::Entities::Customer
    end

    it_behaves_like 'repository creation'

    context 'when the email is duplicated' do
      it 'raises Repositories::RecordNotUnique' do
        described_class.create!(entity)

        expect do
          described_class.create!(entity)
        end.to raise_error(Carpanta::Repositories::RecordInvalid)
      end
    end
  end
end
