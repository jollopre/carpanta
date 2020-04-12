require_relative 'shared_context'
require_relative '../features/shared_context'

RSpec.describe Carpanta::Controllers::Sessions do
  include_context 'requests'

  describe 'GET /customers/1/sessions/new' do
    let!(:task) { FactoryBot.create(:task) }

    it 'returns 200' do
      get '/customers/1/sessions/new'

      expect(last_response.status).to eq(200)
    end

    it 'returns heading' do
      get '/customers/1/sessions/new'

      expect(last_response.body).to have_xpath('//h2', text: 'New Session')
    end

    it 'returns form for filling session' do
      get '/customers/1/sessions/new'

      expect(last_response.body).to have_xpath("//form[@action = '/customers/1/sessions' and @method = 'post']")
      expect(last_response.body).to have_field('session[price]', type: 'number')
      expect(last_response.body).to have_select('session[task_id]', options: ['Dyeing Hair'])
      expect(last_response.body).to have_button('Create')
    end

    it 'includes cancel link' do
      get '/customers/1/sessions/new'

      expect(last_response.body).to have_link('Cancel', href: '/customers/1')
    end
  end

  describe 'POST /customers/:customer_id/sessions' do
    let(:customer) { FactoryBot.create(:customer) }
    let(:task) { FactoryBot.create(:task) }

    context 'when customer DOES NOT exist' do
      it 'returns 422' do
        post '/customers/INVALID/sessions'

        expect(last_response.status).to eq(422)
      end
    end

    context 'when task DOES NOT exist' do
      it 'returns 422' do
        post "/customers/#{customer.id}/sessions", { session: { task_id: 'INVALID' } }

        expect(last_response.status).to eq(422)
      end
    end

    context 'when session is invalid since price is invalid' do
      it 'returns 422' do
        post "/customers/#{customer.id}/sessions", { session: { task_id: task.id } }

        expect(last_response.status).to eq(422)
      end
    end

    it 'creates a session' do
      post "/customers/#{customer.id}/sessions", { session: { task_id: task.id, price: 1234 } }

      expect(last_response.status).to eq(302)
      expect(last_response.headers).to include("Location" => include("/customers/#{customer.id}"))
    end
  end
end
