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

  describe 'GET /customers/:customer_id' do
    context 'when customer DOES NOT exist' do
      it 'returns 404' do
        get '/customers/not_found_id'

        expect(last_response.status).to eq(404)
      end

      it 'returns error message' do
        get '/customers/not_found_id'

        expect(last_response.body).to include('Customer not found')
      end
    end

    context 'when customer exists' do
      let(:customer) { FactoryBot.create(:customer) }
      let(:task) { FactoryBot.create(:task) }
      let!(:session) { FactoryBot.create(:session, customer_id: customer.id, task_id: task.id, price: 1500) }

      it 'returns the sessions for a customer' do
        get "/customers/#{customer.id}"

        expect(last_response.status).to eq(200)
        expect(last_response.body).to have_tag('table') do
          with_tag('td', text: task.name)
          with_tag('td', text: session.price)
          with_tag('td', text: session.created_at)
        end
      end
    end
  end
end
