require 'app/helpers/form_errors'

RSpec.describe Carpanta::Helpers::FormErrors do
  let(:errors) do
    {
      attribute1: ['is invalid']
    }
  end

  subject { described_class.new(errors) }

  describe '#errors?' do
    it 'returns true' do
      result = subject.errors?(:attribute1)

      expect(result).to eq(true)
    end

    context 'when id does not exist in the errors' do
      let(:errors) { {} }

      it 'returns false' do
        result = subject.errors?(:attribute1)

        expect(result).to eq(false)
      end
    end
  end

  describe '#with_error_class' do
    it 'appends errored class' do
      result = subject.with_error_class(id: :attribute1, html_class: 'foo bar baz')

      expect(result).to eq('foo bar baz errored')
    end

    context 'when id does not exist in the errors' do
      let(:errors) { {} }

      it 'errored class is not appended' do
        result = subject.with_error_class(id: :attribute1, html_class: 'foo bar baz')

        expect(result).to eq('foo bar baz')
      end
    end
  end

  describe '#with_aria_entries' do
    it 'merges aria entries' do
      result = subject.with_aria_entries(id: :attribute1, attributes: { foo: 'foo', bar: 'bar' })

      expect(result).to eq({
        foo: 'foo',
        bar: 'bar',
        'aria-describedby': 'attribute1-validation'
      })
    end

    context 'when id does not exist in the errors' do
      let(:errors) { {} }

      it 'aria entries are not merged' do
        result = subject.with_aria_entries(id: :attribute1, attributes: { foo: 'foo', bar: 'bar' })

        expect(result).to eq({
          foo: 'foo',
          bar: 'bar',
        })
      end
    end

    describe '#with_error_entries' do
      it 'returns entries for html paragraph' do
        result = subject.with_error_entries(:attribute1)

        expect(result).to eq({
          class: 'note error',
          id: 'attribute1-validation'
        })
      end
    end

    describe '#errors_to_sentence' do
      let(:errors) do
        {
          attribute1: ['must be present', 'cannot exceed 10 characters']
        }
      end

      it 'returns errors in a sentence' do
        result = subject.errors_to_sentence(:attribute1)

        expect(result).to eq('must be present and cannot exceed 10 characters')
      end
    end
  end
end
