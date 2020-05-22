require_relative 'shared_context'

RSpec.describe 'Appointments resource', type: :feature do
  include_context 'features'

  let(:customer) { FactoryBot.create(:customer) }
  let!(:offer) { FactoryBot.create(:offer) }
  let(:starting_at) { Time.now.utc }
  let(:duration) { 50 }

  it 'creates an appointment' do
    visit "/customers/#{customer.id}/appointments/new"

    page.fill_in 'appointment[starting_at]', with: starting_at
    page.fill_in 'appointment[duration]', with: duration
    page.select offer.name, from: 'appointment[offer_id]'

    click_button 'Create'

    expect(page).to have_text(offer.name)
    expect(page).to have_text(starting_at)
    expect(page).to have_text(duration)
  end
end
