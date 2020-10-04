require 'domain/customers/repository'

RSpec.describe Carpanta::Domain::Customers::Repository do
  describe '.exists?' do
    let(:email) { 'donald.duck@carpanta.com' }

    before do
      FactoryBot.create(:customer)
    end

    it 'returns Success with true' do
      result = described_class.exists?(email: email)

      expect(result.value!).to eq(true)
    end

    context 'when there is no customer meeting the condition' do
      let(:email) { 'non_existent@carpanta.com' }

      it 'returns Success with false' do
        result = described_class.exists?(email: email)

        expect(result.value!).to eq(false)
      end
    end
  end

  describe '.save' do
    let(:customer) { FactoryBot.build(:customer) }

    it 'returns Success' do
      result = described_class.save(customer)

      expect(result.success?).to eq(true)
    end

    context 'when there is an error saving the customer' do
      let(:error) { ActiveRecord::RecordInvalid }

      before do
        allow_any_instance_of(Infra::ORM::Customer).to receive(:save!).and_raise(error)
      end

      it 'returns Failure' do
        result = described_class.save(customer)

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          message: anything,
          backtrace: anything
        )
      end
    end
  end

  describe '.find_by_id' do
    it 'returns Success with the customer' do
      skip('todo')
    end
  end
end
