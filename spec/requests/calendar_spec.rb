require_relative 'shared_context'

RSpec.describe Carpanta::Controllers::Calendar do
  include_context 'requests'

  describe 'GET /calendar/week' do
    let(:date_param) { '2020-12-29' }

    it 'returns 200' do
      get "/calendar/week/#{date_param}"

      expect(last_response.status).to eq(200)
    end

    it 'returns calendar heading' do
      allow(Time).to receive(:now).and_return(Time.new(2021,2,2,8,50,0))
      get "/calendar/week/#{date_param}"

      expect(last_response.body).to have_xpath('//h1', text: 'Calendar')
      expect(last_response.body).to have_xpath('//span[contains(@data-unique_month_year, "")]', text: 'Dec 2020 - Jan 2021')
      expect(last_response.body).to have_link('', href: '/calendar/week/2020-12-22')
      expect(last_response.body).to have_link('', href: '/calendar/week/2021-01-05')
      expect(last_response.body).to have_link('Today', href: '/calendar/week/2021-02-02')
    end

    it 'returns grid heading with weekday name and day of month' do
      get "/calendar/week/#{date_param}"

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[3]', text: 'Mon 28')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[4]', text: 'Tue 29')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[5]', text: 'Wed 30')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[6]', text: 'Thu 31')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[7]', text: 'Fri 01')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[8]', text: 'Sat 02')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gh")]/div[9]', text: 'Sun 03')
    end

    it 'returns grid content with one row per working hour' do
      get "/calendar/week/#{date_param}"

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[2]', text: '07:00')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[32]', text: '22:00')
    end

    it 'returns appointments within the weekly grid content' do
      customer = FactoryBot.create(:customer)
      offer = FactoryBot.create(:offer)
      monday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2020,12,28,17,0,0), duration: 30, customer_id: customer.id, offer_id: offer.id)
      wednesday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2020,12,30,10,0,0), duration: 60, customer_id: customer.id, offer_id: offer.id)
      saturday_appointment = FactoryBot.create(:appointment, starting_at: Time.new(2021,1,2,20,0,0), duration: 90, customer_id: customer.id, offer_id: offer.id)

      get "/calendar/week/#{date_param}"

      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 3; grid-row-start: 23; grid-row-end: 24;")]/a/span', text: monday_appointment.id[0,8])
      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 5; grid-row-start: 9; grid-row-end: 11;")]/a/span', text: wednesday_appointment.id[0,8])
      expect(last_response.body).to have_xpath('//div[contains(@style, "grid-column: 8; grid-row-start: 29; grid-row-end: 32;")]/a/span', text: saturday_appointment.id[0,8])
    end
  end

  describe 'GET /calendar/appointments/:id' do
    let(:customer) { FactoryBot.create(:customer) }
    let(:offer) { FactoryBot.create(:offer) }
    let(:appointment) { FactoryBot.create(:appointment, customer_id: customer.id, offer_id: offer.id) }

    it 'returns 200' do
      get "/calendar/appointments/#{appointment.id}"

      expect(last_response.status).to eq(200)
    end

    it 'returns appointment info, its related offer and customer behind' do
      get "/calendar/appointments/#{appointment.id}"

      expect(last_response.body).to have_content(appointment.id)
      expect(last_response.body).to have_content(appointment.starting_at.utc)
      expect(last_response.body).to have_content(appointment.duration)
      expect(last_response.body).to have_content('Cutting with scissor and Shampooing')
      expect(last_response.body).to have_content('Donald')
      expect(last_response.body).to have_content('Duck')
      expect(last_response.body).to have_content('donald.duck@carpanta.com')
      expect(last_response.body).to have_content('600111222')
    end

    context 'when the appointment DOES NOT exist' do
      it 'returns 404' do
        get '/calendar/appointments/not_found_id'

        expect(last_response.status).to eq(404)
      end

      it 'returns error message' do
        get '/calendar/appointments/not_found_id'

        expect(last_response.body).to include('The resource you are trying to access does not exist.')
      end
    end
  end
end
