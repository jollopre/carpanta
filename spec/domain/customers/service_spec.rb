require 'domain/customers/service'
require 'domain/customers/customer'
require 'domain/customers/errors'
require 'domain/customers/repository_legacy'

RSpec.describe Carpanta::Domain::Customers::Service do
  let(:default_attributes) do
    { name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com', phone: '666111222' }
  end
  let(:customer_class) do
    Carpanta::Domain::Customers::Customer
  end
  let(:customer_instance) do
    customer_class.build(default_attributes)
  end
  let(:invalid_class) do
    Carpanta::Domain::Customers::Errors::Invalid
  end
  let(:repository_class) do
    class_double(Carpanta::Domain::Customers::RepositoryLegacy).as_stubbed_const
  end

  describe '.save!' do
    context 'when there are errors' do
      context 'validating the domain instance' do
        let(:attributes) do
          default_attributes.merge(email: 'wrong@address')
        end

        it 'raises Invalid' do
          expect do
            described_class.save!(attributes)
          end.to raise_error(invalid_class)
        end
      end

      context 'validating uniqueness for email' do
        let(:email_not_unique_class) do
          Carpanta::Domain::Customers::Errors::EmailNotUnique
        end

        it 'raises EmailNotUnique' do
          allow(repository_class).to receive(:exists?).and_return(true)

          expect do
            described_class.save!(default_attributes)
          end.to raise_error(email_not_unique_class)
        end
      end

      it 'creates a customers' do
        allow(repository_class).to receive(:save!).and_return(true)
        allow(repository_class).to receive(:exists?).and_return(false)

        result = described_class.save!(default_attributes)

        expect(repository_class).to have_received(:exists?)
        expect(repository_class).to have_received(:save!)
        expect(result).to be_an_instance_of(customer_class)
      end
    end
  end

  describe '.find_by_id!' do
    it 'forwards into its repository' do
      allow(repository_class).to receive(:find_by_id!).and_return(customer_instance)

      result = described_class.find_by_id!('an_id')

      expect(repository_class).to have_received(:find_by_id!).with('an_id')
      expect(result).to eq(customer_instance)
    end
  end
end
