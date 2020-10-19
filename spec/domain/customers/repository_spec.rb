require 'domain/customers/repository'

RSpec.describe Carpanta::Domain::Customers::Repository do
  subject { described_class.new }

  describe '#exists?' do
    let(:email) { 'donald.duck@carpanta.com' }

    before do
      FactoryBot.create(:customer)
    end

    it 'returns Success' do
      result = subject.exists?(email: email)

      expect(result.success?).to eq(true)
    end

    context 'when there is no customer meeting the condition' do
      let(:email) { 'non_existent@carpanta.com' }

      it 'returns Failure' do
        result = subject.exists?(email: email)

        expect(result.failure?).to eq(true)
      end
    end
  end

  describe '#save' do
    let(:customer) { FactoryBot.build(:customer) }

    it 'returns Success' do
      result = subject.save(customer)

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
        result = subject.save(customer)

        expect(result.failure?).to eq(true)
      end
    end
  end

  describe '#find_by_id' do
    let(:customer_class) { Carpanta::Domain::Customers::Customer }
    let!(:customer) { FactoryBot.create(:customer) }

    it 'returns Success with the customer' do
      result = subject.find_by_id(customer.id)

      expect(result.value!).to be_an_instance_of(customer_class)
      expect(result.value!).to eq(customer)
    end

    context 'when the customer is not found' do
      it 'returns Failure' do
        result = subject.find_by_id('non_existent_id')

        expect(result.failure?).to eq(true)
      end
    end
  end
end
