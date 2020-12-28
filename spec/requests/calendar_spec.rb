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

      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[1]', text: '07:00')
      expect(last_response.body).to have_xpath('//div[contains(@class, "weekly-gc")]/div[16]', text: '22:00')
    end

    it 'returns appointments within the weekly grid content' do
      skip('todo')
    end
  end
end
