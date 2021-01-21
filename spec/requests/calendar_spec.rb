require_relative 'shared_context'

RSpec.describe Carpanta::Controllers::Calendar do
  include_context 'requests'

  describe 'GET /calendar/week' do
    let(:date) { Date.new(2021,1,14) }

    it 'returns 200' do
      skip
      get "/calendar/week/#{date}"

      expect(last_response.status).to eq(200)
    end

    it 'returns calendar heading' do
      skip
      get "/calendar/week/#{Date.new(2020,1,29)}"

      expect(last_response.body).to have_xpath('//h1', text: 'Calendar')
      expect(last_response.body).to have_xpath('//div[contains(@class, "Subhead-heading")]/p', text: 'Dec 2020 - Jan 2021')
    end

    it 'returns grid heading with weekday name and day of month' do
      skip
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
      skip
      get '/calendar/week'

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[2]', text: '07:00')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[32]', text: '22:00')
    end

    it 'returns appointments within the weekly grid content' do
      customer = FactoryBot.create(:customer)
      offer = FactoryBot.create(:offer)
      monday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2021,1,11,17,0,0), duration: 30, customer_id: customer.id, offer_id: offer.id)
      wednesday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2021,1,13,10,0,0), duration: 60, customer_id: customer.id, offer_id: offer.id)
      saturday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2021,1,16,20,0,0), duration: 90, customer_id: customer.id, offer_id: offer.id)

      get "/calendar/week/#{date}"

      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 3; grid-row-start: 23; grid-row-end: 24;")]/a/span', text: monday_appointment.id)
      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 5; grid-row-start: 9; grid-row-end: 11;")]/a/span', text: wednesday_appointment.id)
      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 8; grid-row-start: 29; grid-row-end: 32;")]/a/span', text: saturday_appointment.id)
    end
  end
end
