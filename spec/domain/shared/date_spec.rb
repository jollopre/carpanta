require 'domain/shared/date'

RSpec.describe Domain::Shared::Date do
  describe '.cwdays' do
    RSpec.shared_examples 'current week starting on Monday' do
      before do
        allow(Date).to receive(:today).and_return(today)
      end

      it 'returns dates of the current week starting on Monday' do
        result = described_class.cwdays

        expect(result).to start_with([
          Date.new(2020,11,23),
          Date.new(2020,11,24),
          Date.new(2020,11,25),
          Date.new(2020,11,26),
          Date.new(2020,11,27),
          Date.new(2020,11,28),
          Date.new(2020,11,29)
        ])
      end
    end

    context 'when today is Monday' do
      let(:today) { Date.new(2020,11,23) }
      it_behaves_like 'current week starting on Monday'
    end

    context 'when today is Sunday' do
      let(:today) { Date.new(2020,11,29) }
      it_behaves_like 'current week starting on Monday'
    end

    context 'otherwise' do
      let(:today) { Date.new(2020,11,25) }
      it_behaves_like 'current week starting on Monday'
    end
  end
end
