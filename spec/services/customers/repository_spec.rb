require 'app/services/customers/repository'

RSpec.describe Carpanta::Services::Customers::Repository do
  describe '.create' do
    it 'returns a persisted customer'

    context 'when the customer cannot be persisted' do
      context 'since uniqueness validation DOES NOT pass' do
        it 'returns a customer with errors'
      end
    end
  end
end
