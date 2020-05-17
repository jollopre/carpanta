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

    it 'includes link for new customer' do
      get '/customers'

      expect(last_response.body).to have_link('New Customer', href: '/customers/new')
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

    it 'includes cancel link' do
      get '/customers/new'

      expect(last_response.body).to have_link('Cancel', href: '/customers')
    end
  end

  describe 'POST /customers' do
    context 'when customer is invalid' do
      it 'returns 422' do
        post '/customers', { customer: { email: 'donald@' }}

        expect(last_response.status).to eq(422)
      end

      context 'since email is not unique' do
        before do
          FactoryBot.create(:customer, email: 'donald.duck@carpanta.com')
        end

        it 'returns 422' do
          post '/customers', { customer: { name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com' }}

          expect(last_response.status).to eq(422)
        end
      end
    end

    it 'creates a customer' do
      post '/customers', { customer: { name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com' }}

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

      it 'returns 200 status' do
        get "/customers/#{customer.id}"

        expect(last_response.status).to eq(200)
      end

      it 'returns the details for a customer' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_xpath('//dl/dt[1]', text: 'Name')
        expect(last_response.body).to have_xpath('//dl/dd[1]', text: customer.name)
        expect(last_response.body).to have_xpath('//dl/dt[2]', text: 'Surname')
        expect(last_response.body).to have_xpath('//dl/dd[2]', text: customer.surname)
        expect(last_response.body).to have_xpath('//dl/dt[3]', text: 'Email')
        expect(last_response.body).to have_xpath('//dl/dd[3]', text: customer.email)
        expect(last_response.body).to have_xpath('//dl/dt[4]', text: 'Phone')
        expect(last_response.body).to have_xpath('//dl/dd[4]', text: customer.phone)
      end

      it 'includes link to return to the list of customers' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_link('Back', href: '/customers')
      end

      context 'session list' do
        it 'includes task name' do
          get "/customers/#{customer.id}"

          expect(last_response.body).to have_xpath('//table/tr[2]/td[1]', text: task.name)
        end

        it 'includes price formatted' do
          get "/customers/#{customer.id}"

          expect(last_response.body).to have_xpath('//table/tr[2]/td[2]', exact_text: '15.00 €')
        end

        it 'includes created_at' do
          get "/customers/#{customer.id}"

          expect(last_response.body).to have_xpath('//table/tr[2]/td[3]', text: session.created_at)
        end
      end

      it 'permits adding new session' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_link('New Session', href: "/customers/#{customer.id}/sessions/new")
      end
    end
  end

  describe 'POST /customers/:customer_id/appointments' do
    let(:customer) { FactoryBot.create(:customer) }
    let(:offer) { FactoryBot.create(:offer) }
    let(:starting_at) { Time.now.iso8601 }

    it 'creates an appointment for a customer' do
      post "/customers/#{customer.id}/appointments", { appointment: { offer_id: offer.id, starting_at: starting_at } }

      expect(last_response.status).to eq(302)
      expect(last_response.headers).to include("Location" => include("/customers/#{customer.id}"))
    end

    context 'when the appointment is invalid' do
      it 'returns 422' do
        post "/customers/#{customer.id}/appointments", { appointment: { offer_id: offer.id, starting_at: nil } }

        expect(last_response.status).to eq(422)
      end

      it 'body includes errors' do
        post "/customers/#{customer.id}/appointments", { appointment: { offer_id: offer.id, starting_at: nil } }

        expected_errors = { starting_at: [{ error: :blank }]}.to_json
        expect(last_response.body).to include(expected_errors)
      end
    end
  end
end
