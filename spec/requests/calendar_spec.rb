require_relative 'shared_context'

RSpec.describe Carpanta::Controllers::Calendar do
  include_context 'requests'

  describe 'GET /calendar/week' do
    let(:today) { Date.new(2020,12,28) }
    before do
      allow(Date).to receive(:today).and_return(today)
    end

    it 'returns 200' do
      get '/calendar/week'

      expect(last_response.status).to eq(200)
    end

    it 'returns calendar heading' do
      get '/calendar/week'

      expect(last_response.body).to have_xpath('//h1', text: 'Calendar')
      expect(last_response.body).to have_xpath('//div[contains(@class, "Subhead-heading")]/p', text: 'Dec 2020 - Jan 2021')
    end

    it 'returns grid heading with weekday name and day of month' do
      get '/calendar/week'

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[3]', text: 'Mon 28')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[4]', text: 'Tue 29')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[5]', text: 'Wed 30')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[6]', text: 'Thu 31')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[7]', text: 'Fri 01')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[8]', text: 'Sat 02')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[9]', text: 'Sun 03')
    end

    it 'returns grid content with one row per working hour' do
      get '/calendar/week'

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[2]', text: '07:00')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[32]', text: '22:00')
    end

    it 'returns appointments within the weekly grid content' do
      customer = FactoryBot.create(:customer)
      offer = FactoryBot.create(:offer)
      monday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2020,12,28,17,0,0), duration: 30, customer_id: customer.id, offer_id: offer.id)
      wednesday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2020, 12, 30, 10,0,0), duration: 60, customer_id: customer.id, offer_id: offer.id)
      saturday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2021,1,2, 20,0,0), duration: 90, customer_id: customer.id, offer_id: offer.id)

      get '/calendar/week'

      skip('todo')
    end
  end
end
