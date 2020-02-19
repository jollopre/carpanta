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
  end
end
