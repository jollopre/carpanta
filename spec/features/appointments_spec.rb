require_relative 'shared_context'

RSpec.describe 'Appointments resource', type: :feature do
  include_context 'features'

  let(:customer) { FactoryBot.create(:customer) }
  let!(:offer) { FactoryBot.create(:offer, tasks: ['Cutting', 'Shampooing']) }
  let(:starting_at) { Time.new(2020,05,26,07,45,12) }
  let(:duration) { 50 }

  it 'creates an appointment' do
    visit "/customers/#{customer.id}/appointments/new"

    page.fill_in 'appointment[starting_at]', with: starting_at
    page.fill_in 'appointment[duration]', with: duration
    page.select 'Cutting and Shampooing', from: 'appointment[offer_id]'

    click_button 'Create'

    expect(page).to have_text('Cutting and Shampooing')
    expect(page).to have_text('2020-05-26T07:45:12Z')
    expect(page).to have_text(duration)
  end
end
