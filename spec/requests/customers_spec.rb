require_relative 'shared_context'

RSpec.describe Carpanta::Controllers::Customers do
  include_context 'requests'

  describe 'GET /customers' do
    let!(:customer) { FactoryBot.create(:customer) }

    it 'returns 200' do
      get '/customers'

      expect(last_response.status).to eq(200)
    end

    it 'returns customers heading' do
      get '/customers'

      expect(last_response.body).to have_xpath('//h2', text: 'Customers')
    end

    it 'returns list of customers' do
      get '/customers'

      expect(last_response.body).to have_xpath('//table/tr[2]/td[1]', text: 'Donald')
      expect(last_response.body).to have_xpath('//table/tr[2]/td[2]', text: 'Duck')
      expect(last_response.body).to have_xpath('//table/tr[2]/td[3]', text: 'donald.duck@carpanta.com')
      expect(last_response.body).to have_xpath('//table/tr[2]/td[4]', text: '600111222')
      expect(last_response.body).to have_link('Show', href: "/customers/#{customer.id}")
    end
  end

  describe 'GET /customers/new' do
    it 'returns 200' do
      get '/customers/new'

      expect(last_response.status).to eq(200)
    end

    it 'returns form for filling customer' do
      get '/customers/new'

      expect(last_response.body).to have_xpath("//form[@action = '/customers' and @method = 'post']")
      expect(last_response.body).to have_field('customer[name]', type: 'text')
      expect(last_response.body).to have_field('customer[surname]', type: 'text')
      expect(last_response.body).to have_field('customer[email]', type: 'email')
      expect(last_response.body).to have_field('customer[phone]', type: 'tel')
      expect(last_response.body).to have_button('Create')
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

        expect(last_response.body).to have_xpath('//table/tr[2]/td[1]', text: task.name)
        expect(last_response.body).to have_xpath('//table/tr[2]/td[2]', text: session.price)
        expect(last_response.body).to have_xpath('//table/tr[2]/td[3]', text: session.created_at)
      end

      it 'permits adding new session' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_link('New Session', href: "/customers/#{customer.id}/sessions/new")
      end
    end
  end
end
