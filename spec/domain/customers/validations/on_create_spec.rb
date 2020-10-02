require 'domain/customers/validations/on_create'
require 'spec/domain/shared/shared_examples'

RSpec.describe Carpanta::Domain::Customers::Validations::OnCreate do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com'
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'name' do
        it_behaves_like 'must be a string', { name: 123 }, :name
      end

      context 'surname' do
        it_behaves_like 'must be a string', { surname: 123 }, :surname
      end

      context 'email' do
        it_behaves_like 'is in invalid format', { email: 'donald.duck@carpanta' }, :email
      end
    end
  end
end
