require "domain/customers/services/create_customer"
require "domain/offers/services/create_offer"
require "domain/appointments/services/create_appointment"

lambda do
  offers_attrs =
    [
      {tasks: ["Corte Caballero con lavado"], price: 1000},
      {tasks: ["Arreglo de barba"], price: 500},
      {tasks: ["Arreglo flequillo"], price: 300},
      {tasks: ["Corte nin@"], price: 500},
      {tasks: ["Lavar", "secar"], price: 1200},
      {tasks: ['Retoque "mentira"', "lavar", "secar"], price: 1800},
      {tasks: ["Corte", 'secado "al aire"'], price: 1500},
      {tasks: ["Corte", "secado"], price: 2500},
      {tasks: ["Color", "secado"], price: 3500},
      {tasks: ["Color", "secado", "corte"], price: 4000},
      {tasks: ["Mechas para iluminar en frontal"], price: 1500},
      {tasks: ['Mechas pelo corto "al aire"'], price: 2500},
      {tasks: ["Mechas pelo corto", "secado"], price: 3000},
      {tasks: ["Mechas pelo corto", "corte", "secado"], price: 3500},
      {tasks: ["Mechas", "secado"], price: 4000},
      {tasks: ["Mechas", "secado", "corte"], price: 5000},
      {tasks: ["Degradado", "secado"], price: 4500},
      {tasks: ["Degradado con retoque raiz", "secado"], price: 6000},
      {tasks: ["Degradado con retoque de raiz", "corte", "secado"], price: 6500},
      {tasks: ["Matiz"], price: 1500},
      {tasks: ["Deco arrastre"], price: 9000},
      {tasks: ["Color global"], price: 5000},
      {tasks: ["Alisado ORGANIC"], price: 150},
      {tasks: ["Permanente"], price: 3500},
      {tasks: ["Peinado de fallera"], price: 3000},
      {tasks: ["Peinado de fallera cosido"], price: 2500},
      {tasks: ["Recogido fiesta"], price: 3000},
      {tasks: ["Tratamiento ELUMEN"], price: 3000},
      {tasks: ["Tratamiento REPARADOR", "secado"], price: 3500}
    ]

  customers_attrs =
    [
      {name: "Ben", surname: "Dover", email: "ben.dover@carpanta.com", phone: "600111222"},
      {name: "Hermione", surname: "Byrne", email: "hermione.byrne@carpanta.com", phone: "600111222"},
      {name: "Felix", surname: "Burns", email: "felix.burns@carpanta.com", phone: "600111222"},
      {name: "Eden", surname: "Davenport", email: "eden.davenport@carpanta.com", phone: "600111222"},
      {name: "Isabella", surname: "Mckinney", email: "isabella.mckinney@carpanta.com", phone: "600111222"},
      {name: "Teresa", surname: "Le", email: "teresa.le@carpanta.com", phone: "600111222"},
      {name: "Casey", surname: "Salazar", email: "casey.salazar@carpanta.com", phone: "600111222"},
      {name: "Fatima", surname: "Sanchez", email: "fatima.sanchez@carpanta.com", phone: "600111222"},
      {name: "Pearl", surname: "Baxter", email: "pearl.baxter@carpanta.com", phone: "600111222"},
      {name: "Molly", surname: "Barron", email: "molly.barron@carpanta.com", phone: "600111222"}
    ]

  offer_ids = offers_attrs.map do |offer_attrs|
    Carpanta::Domain::Offers::Services::CreateOffer.call(offer_attrs).value!
  end

  customer_ids = customers_attrs.map do |customer_attrs|
    Carpanta::Domain::Customers::Services::CreateCustomer.call(customer_attrs).value!
  end

  unique_appointment_attrs_generator_class = Class.new do
    def initialize
      @latest_starting_at = Time.new(now.year, now.month, now.day, now.hour, 0, 0)
      @latest_duration = duration_generator
      @seconds = 60
    end

    def call
      @latest_starting_at = starting_at_generator
      @latest_duration = duration_generator

      {starting_at: latest_starting_at, duration: latest_duration}
    end

    private

    def delta
      [0, duration_generator].sample
    end

    def starting_at_generator
      (latest_starting_at + latest_duration * @seconds) + (delta * @seconds)
    end

    def duration_generator
      [30, 60, 90].sample
    end

    def now
      Time.now
    end

    attr_reader :latest_starting_at, :latest_duration
  end

  unique_appointment_attrs_generator = unique_appointment_attrs_generator_class.new

  create_appointment = lambda do |customer_id, offer_id|
    unique_appointment_attrs = unique_appointment_attrs_generator.call
    attributes = {
      customer_id: customer_id,
      offer_id: offer_id,
      starting_at: unique_appointment_attrs.fetch(:starting_at).utc.iso8601,
      duration: unique_appointment_attrs.fetch(:duration)
    }
    Carpanta::Domain::Appointments::Services::CreateAppointment.call(attributes).value!
  end

  customer_ids.each do |customer_id|
    10.times do
      create_appointment.call(customer_id, offer_ids.sample)
    end
  end
end.call
