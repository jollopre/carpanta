require_relative 'shared_context'

RSpec.describe Carpanta::Controllers::Customers do
  include_context 'requests'

  describe 'GET /customers' do
    before do
      FactoryBot.create(:customer)
    end

    it 'returns 200' do
      get '/customers'

      expect(last_response.status).to eq(200)
    end

    it 'returns customers heading' do
      get '/customers'

      expect(last_response.body).to have_tag('h2', text: 'Customers')
    end

    it 'returns list of customers' do
      get '/customers'

      expect(last_response.body).to have_tag('table') do
        with_tag('td', text: 'Donald')
        with_tag('td', text: 'Duck')
        with_tag('td', text: 'donald.duck@carpanta.com')
        with_tag('td', text: '600111222')
      end
    end
  end

  describe 'GET /customers/new' do
    it 'returns 200' do
      get '/customers/new'

      expect(last_response.status).to eq(200)
    end

    it 'returns form for filling customer' do
      get '/customers/new'

      expect(last_response.body).to have_form('/customers', 'post') do
        with_text_field('customer[name]')
        with_text_field('customer[surname]')
        with_email_field('customer[email]')
        with_tag('input', with: { type: 'tel', name: 'customer[phone]' })
        with_submit('Create')
      end
    end
  end

  describe 'POST /customers' do
    context 'when customer is invalid' do
      it 'returns 422' do
        post '/customers', { customer: { email: 'donald@' }}

        expect(last_response.status).to eq(422)
      end
    end

    it 'creates a customer' do
      post '/customers', { customer: { email: 'donald.duck@carpanta.com' }}

      expect(last_response.status).to eq(302)
    end
  end
end
