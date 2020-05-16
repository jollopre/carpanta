require 'domain/shared/result'

RSpec.describe Carpanta::Domain::Shared::Result do
  let(:a_class) do
    Class.new do
      extend Carpanta::Domain::Shared::Result
    end
  end

  describe '.success' do
    it 'returns result instance whose success is yieldable' do
      result = a_class.success('foo')

      expect do |b|
        result.success(&b)
      end.to yield_with_args('foo')
    end
  end

  describe '.failure' do
    it 'returns result instance whose failure is yieldable' do
      result = a_class.failure('foo')

      expect do |b|
        result.failure(&b)
      end.to yield_with_args('foo')
    end
  end
end

RSpec.describe Carpanta::Domain::Shared::ResultClass do
  RSpec.shared_examples 'result reader' do |type|
    describe "##{type}" do
      let(:result) { described_class.new }

      it "yields the #{type}" do
        result.send("#{type}=", 'foo')

        expect do |b|
          result.send(type, &b)
        end.to yield_with_args('foo')
      end

      context "when #{type} is not set" do
        it "does not yield #{type}" do
          expect do |b|
            result.send(type, &b)
          end.not_to yield_with_args
        end
      end

      context 'when block is not passed' do
        it 'does not raise error' do
          expect do
            result.send(type)
          end.not_to raise_error
        end
      end
    end
  end

  it_behaves_like 'result reader', :success
  it_behaves_like 'result reader', :failure

  describe '#success' do
    context 'when is set' do
      it 'failure is not yield' do
        result = described_class.new

        result.failure='foo'
        result.success='foo'

        expect do |b|
          result.failure(&b)
        end.not_to yield_with_args
      end
    end
  end

  describe '#failure' do
    context 'when is set' do
      it 'success is not yield' do
        result = described_class.new

        result.success='foo'
        result.failure='foo'

        expect do |b|
          result.success(&b)
        end.not_to yield_with_args
      end
    end
  end
end
