require "app/commands/create_appointment"

RSpec.describe Carpanta::Commands::CreateAppointment do
  describe ".call" do
    let(:default_attributes) do
      FactoryBot.attributes_for(:appointment)
    end

    it "forwards into appointments domain for creating appointment" do
      expect(Carpanta::Domain::Appointments::Services::CreateAppointment).to receive(:call).with(default_attributes)

      described_class.call(default_attributes)
    end
  end
end
