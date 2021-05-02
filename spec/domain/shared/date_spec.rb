require "domain/shared/date"

RSpec.describe Domain::Shared::Date do
  describe "#beginning_of_week" do
    RSpec.shared_examples "must be a date" do |date|
      let(:monday) { Date.new(2021, 1, 11) }

      it "starting on Monday" do
        date_decorator = described_class.new(date)

        expect(date_decorator.beginning_of_week).to eq(monday)
      end
    end

    it_behaves_like "must be a date", Date.new(2021, 1, 11) # monday
    it_behaves_like "must be a date", Date.new(2021, 1, 12) # tuesday
    it_behaves_like "must be a date", Date.new(2021, 1, 13) # wednesday
    it_behaves_like "must be a date", Date.new(2021, 1, 14) # thursday
    it_behaves_like "must be a date", Date.new(2021, 1, 15) # friday
    it_behaves_like "must be a date", Date.new(2021, 1, 16) # saturday
    it_behaves_like "must be a date", Date.new(2021, 1, 17) # sunday
  end

  describe "#end_of_week" do
    RSpec.shared_examples "must be a date" do |date|
      let(:sunday) { Date.new(2021, 1, 17) }

      it "ending on Sunday" do
        date_decorator = described_class.new(date)

        expect(date_decorator.end_of_week).to eq(sunday)
      end
    end

    it_behaves_like "must be a date", Date.new(2021, 1, 11) # monday
    it_behaves_like "must be a date", Date.new(2021, 1, 12) # tuesday
    it_behaves_like "must be a date", Date.new(2021, 1, 13) # wednesday
    it_behaves_like "must be a date", Date.new(2021, 1, 14) # thursday
    it_behaves_like "must be a date", Date.new(2021, 1, 15) # friday
    it_behaves_like "must be a date", Date.new(2021, 1, 16) # saturday
    it_behaves_like "must be a date", Date.new(2021, 1, 17) # sunday
  end

  describe "#today?" do
    let(:date) { Date.new(2021, 1, 21) }
    subject { described_class.new(date) }

    it "returns false" do
      result = subject.today?

      expect(result).to eq(false)
    end

    context "when date is today" do
      before do
        allow(Date).to receive(:today).and_return(date)
      end

      it "returns true" do
        result = subject.today?

        expect(result).to eq(true)
      end
    end
  end

  describe "#strftime" do
    subject { described_class.new(Date.new(2021, 1, 22)) }

    it "responds to strftime method" do
      expect(subject).to respond_to(:strftime)
    end
  end

  describe "#days_of_week" do
    subject { described_class.new(Date.new(2021, 1, 22)) }

    it "returns the days of the week within a date" do
      result = subject.days_of_week

      expect(result).to eq([
        Date.new(2021, 1, 18),
        Date.new(2021, 1, 19),
        Date.new(2021, 1, 20),
        Date.new(2021, 1, 21),
        Date.new(2021, 1, 22),
        Date.new(2021, 1, 23),
        Date.new(2021, 1, 24)
      ])
    end

    it "all are instance of Shared::Date" do
      result = subject.days_of_week

      expect(result).to all(be_an_instance_of(Domain::Shared::Date))
    end
  end
end
