require 'domain/shared/date'

RSpec.describe Domain::Shared::Date do
  describe '#beginning_of_week' do
    RSpec.shared_examples 'must be a date' do |date|
      let(:monday) { Date.new(2021,1,11) }

      it 'starting on Monday' do
        date_decorator = described_class.new(date)

        expect(date_decorator.beginning_of_week).to eq(monday)
      end
    end

    it_behaves_like 'must be a date', Date.new(2021,1,11) # monday
    it_behaves_like 'must be a date', Date.new(2021,1,12) # tuesday
    it_behaves_like 'must be a date', Date.new(2021,1,13) # wednesday
    it_behaves_like 'must be a date', Date.new(2021,1,14) # thursday
    it_behaves_like 'must be a date', Date.new(2021,1,15) # friday
    it_behaves_like 'must be a date', Date.new(2021,1,16) # saturday
    it_behaves_like 'must be a date', Date.new(2021,1,17) # sunday
  end

  describe '#end_of_week' do
    RSpec.shared_examples 'must be a date' do |date|
      let(:sunday) { Date.new(2021,1,17) }

      it 'ending on Sunday' do
        date_decorator = described_class.new(date)

        expect(date_decorator.end_of_week).to eq(sunday)
      end
    end

    it_behaves_like 'must be a date', Date.new(2021,1,11) # monday
    it_behaves_like 'must be a date', Date.new(2021,1,12) # tuesday
    it_behaves_like 'must be a date', Date.new(2021,1,13) # wednesday
    it_behaves_like 'must be a date', Date.new(2021,1,14) # thursday
    it_behaves_like 'must be a date', Date.new(2021,1,15) # friday
    it_behaves_like 'must be a date', Date.new(2021,1,16) # saturday
    it_behaves_like 'must be a date', Date.new(2021,1,17) # sunday
  end
end
