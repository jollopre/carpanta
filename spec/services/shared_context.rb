require 'app/services/errors'

RSpec.shared_context 'services errors' do
  let!(:record_invalid) do
    Carpanta::Services::Errors::RecordInvalid
  end
end
