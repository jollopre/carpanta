RSpec.shared_context 'features' do
  before do
    Capybara.app = Carpanta::Controllers::Application
  end
end
