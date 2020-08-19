require 'domain/shared/result'

RSpec.describe Carpanta::Domain::Shared::Result do
  let(:a_class) do
    Class.new do
      extend Carpanta::Domain::Shared::Result
    end
  end

  describe '.success' do
    it 'returns an instance of Success' do
      result = a_class.success('foo')

      expect(result).to be_an_instance_of(Dry::Monads::Result::Success)
    end
  end

  describe '.failure' do
    it 'returns an instance of Failure' do
      result = a_class.failure('an_error')

      expect(result).to be_an_instance_of(Dry::Monads::Result::Failure)
    end
  end
end
