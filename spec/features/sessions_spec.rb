require_relative 'shared_context'

RSpec.describe 'Sessions resource', type: :feature do
  include_context 'features'

  let(:customer) { FactoryBot.create(:customer) }
  let!(:task) { FactoryBot.create(:task) }
  let(:price) { 1234 }

  it 'creates a session' do
    visit "/customers/#{customer.id}/sessions/new"

    page.fill_in 'session[price]', with: price
    page.select task.name, from: 'session[task_id]'

    click_button 'Create'

    expect(page).to have_text(task.name)
    expect(page).to have_text(price)
  end
end
