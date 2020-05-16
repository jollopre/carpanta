require 'app/commands/create_appointment'
require 'domain/appointments/repository'

RSpec.describe Carpanta::Commands::CreateAppointment do
  let(:repository_class) do
    Carpanta::Domain::Appointments::Repository
  end

  describe '.call' do
    let(:default_attributes) do
      FactoryBot.attributes_for(:appointment)
    end

    it 'result success yields with the appointment id' do
      result = described_class.call(default_attributes)

      expect do |b|
        result.success(&b)
      end.to yield_with_args(an_instance_of(String))
    end

    context 'when the appointment is invalid' do
      let(:attributes) do
        default_attributes.merge(starting_at: nil)
      end

      it 'result failure yields with the errors' do
        result = described_class.call(attributes)

        expected_errors = { starting_at: [{ error: :blank }] }
        expect do |b|
          result.failure(&b)
        end.to yield_with_args(expected_errors)
      end
    end
  end
end
