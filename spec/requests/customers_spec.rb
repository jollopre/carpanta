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

      it 'body includes `errored class` for form-group belonging the input' do
        post '/customers', { customer: { name: '', surname: '', email: 'donald@' }}

        expect(last_response.body).to have_xpath('//*[@id="name"]//ancestor::div[@class="form-group mb-4 errored"]')
        expect(last_response.body).to have_xpath('//*[@id="surname"]//ancestor::div[@class="form-group mb-4 errored"]')
        expect(last_response.body).to have_xpath('//*[@id="email"]//ancestor::div[@class="form-group mb-4 errored"]')
      end

      it 'body includes value input from request' do
        post '/customers', { customer: { name: '', surname: '', email: 'donald@' }}

        expect(last_response.body).to have_field('customer[email]', with: 'donald@')
      end

      it 'body includes validation errors' do
        post '/customers', { customer: { email: 'donald@' }}

        expect(last_response.body).to have_xpath('//*[@id="name-validation"]')
        expect(last_response.body).to have_xpath('//*[@id="surname-validation"]')
        expect(last_response.body).to have_xpath('//*[@id="email-validation"]')
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

        expect(last_response.body).to include('The resource you are trying to access does not exist.')
      end
    end

    context 'when customer exists' do
      let(:customer) { FactoryBot.create(:customer) }
      let(:offer) { FactoryBot.create(:offer, tasks: ['Cutting', 'Shampooing']) }
      let(:starting_at) { Time.new(2020,05,26,07,45,12) }
      let!(:appointment) { FactoryBot.create(:appointment, customer_id: customer.id, offer_id: offer.id, starting_at: starting_at) }

      it 'returns 200 status' do
        get "/customers/#{customer.id}"

        expect(last_response.status).to eq(200)
      end

      it 'returns the details for a customer' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_content('Name')
        expect(last_response.body).to have_content(customer.name)
        expect(last_response.body).to have_content('Surname')
        expect(last_response.body).to have_content(customer.surname)
        expect(last_response.body).to have_content('Email')
        expect(last_response.body).to have_content(customer.email)
        expect(last_response.body).to have_content('Phone')
        expect(last_response.body).to have_content(customer.phone)
      end

      it 'includes link to return to the list of customers' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_link('Back', href: '/customers')
      end

      context 'appointment list' do
        it 'includes offer name' do
          get "/customers/#{customer.id}"

          expect(last_response.body).to have_content('Cutting and Shampooing')
        end

        it 'includes starting_at' do
          get "/customers/#{customer.id}"

          starting_at_iso8601 = '2020-05-26T07:45:12Z'
          expect(last_response.body).to have_xpath("//time[@datetime='#{starting_at_iso8601}']")
          expect(last_response.body).to have_content(starting_at_iso8601)
        end

        it 'includes duration' do
          get "/customers/#{customer.id}"

          expect(last_response.body).to have_content(appointment.duration)
        end
      end

      it 'permits adding new appointment' do
        get "/customers/#{customer.id}"

        expect(last_response.body).to have_link('New Appointment', href: "/customers/#{customer.id}/appointments/new")
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
      let(:attributes) do
        { appointment: { duration: -1, starting_at: nil, offer_id: nil }}
      end

      it 'returns 422' do
        post "/customers/#{customer.id}/appointments", attributes

        expect(last_response.status).to eq(422)
      end

      it 'body includes `errored class` for form-group belonging the input' do
        post "/customers/#{customer.id}/appointments", attributes

        expect(last_response.body).to have_xpath('//*[@id="duration"]//ancestor::div[@class="form-group mb-4 errored"]')
        expect(last_response.body).to have_xpath('//*[@id="starting_at"]//ancestor::div[@class="form-group mb-4 errored"]')
        expect(last_response.body).to have_xpath('//*[@id="offer_id"]//ancestor::div[@class="form-group mb-4 errored"]')
      end

      it 'body includes value input from request' do
        post "/customers/#{customer.id}/appointments", attributes.merge(starting_at: starting_at)

        expect(last_response.body).to have_field('appointment[duration]', with: '-1')
        skip('appointment[starting_at] includes datetime input')
      end

      it 'body includes validation errors' do
        post "/customers/#{customer.id}/appointments", attributes

        expect(last_response.body).to have_xpath('//*[@id="duration-validation"]')
        expect(last_response.body).to have_xpath('//*[@id="starting_at-validation"]')
        expect(last_response.body).to have_xpath('//*[@id="offer_id-validation"]')
      end
    end
  end

  describe 'GET /customers/:customer_id/appointments/new' do
    let(:customer) { FactoryBot.create(:customer) }

    it 'returns 200' do
      get "/customers/#{customer.id}/appointments/new"

      expect(last_response.status).to eq(200)
    end

    context 'rendered form' do
      let!(:offer) { FactoryBot.create(:offer) }

      it 'includes action, method and submit' do
        get "/customers/#{customer.id}/appointments/new"

        expected_url = "/customers/#{customer.id}/appointments"
        expect(last_response.body).to have_xpath("//form[@action = '#{expected_url}' and @method = 'post']")
        expect(last_response.body).to have_button('Create')
      end

      it 'includes starting_at field' do
        get "/customers/#{customer.id}/appointments/new"

        expect(last_response.body).to have_field('appointment[starting_at]', type: 'datetime-local')
      end

      it 'includes duration field' do
        get "/customers/#{customer.id}/appointments/new"

        expect(last_response.body).to have_field('appointment[duration]', type: 'number')
      end

      it 'includes select for offers' do
        get "/customers/#{customer.id}/appointments/new"

        expect(last_response.body).to have_select('appointment[offer_id]', options: ['Cutting with scissor and Shampooing'])
      end

      it 'includes cancel link' do
        get "/customers/#{customer.id}/appointments/new"

        expect(last_response.body).to have_link('Cancel', href: "/customers/#{customer.id}")
      end
    end
  end
end
