require 'domain/offers/offer'
require 'domain/offers/repository'
require 'domain/customers/service'
require 'app/commands/create_appointment'

lambda do
  offers_attrs =
    [
      { tasks: ['Corte Caballero con lavado'], price: 1000 },
      { tasks: ['Arreglo de barba'], price: 500 },
      { tasks: ['Arreglo flequillo'], price: 300 },
      { tasks: ['Corte nin@'], price: 500 },
      { tasks: ['Lavar', 'secar'], price: 1200 },
      { tasks: ['Retoque "mentira"', 'lavar', 'secar'], price: 1800 },
      { tasks: ['Corte', 'secado "al aire"'], price: 1500 },
      { tasks: ['Corte', 'secado'], price: 2500 },
      { tasks: ['Color', 'secado'], price: 3500 },
      { tasks: ['Color', 'secado', 'corte'], price: 4000 },
      { tasks: ['Mechas para iluminar en frontal'], price: 1500 },
      { tasks: ['Mechas pelo corto "al aire"'], price: 2500 },
      { tasks: ['Mechas pelo corto', 'secado'], price: 3000 },
      { tasks: ['Mechas pelo corto', 'corte', 'secado'], price: 3500 },
      { tasks: ['Mechas', 'secado'], price: 4000 },
      { tasks: ['Mechas', 'secado', 'corte'], price: 5000 },
      { tasks: ['Degradado', 'secado'], price: 4500 },
      { tasks: ['Degradado con retoque raiz', 'secado'], price: 6000 },
      { tasks: ['Degradado con retoque de raiz', 'corte', 'secado'], price: 6500 },
      { tasks: ['Matiz'], price: 1500 },
      { tasks: ['Deco arrastre'], price: 9000 },
      { tasks: ['Color global'], price: 5000 },
      { tasks: ['Alisado ORGANIC'], price: 150 },
      { tasks: ['Permanente'], price: 3500 },
      { tasks: ['Peinado de fallera'], price: 3000 },
      { tasks: ['Peinado de fallera cosido'], price: 2500 },
      { tasks: ['Recogido fiesta'], price: 3000 },
      { tasks: ['Tratamiento ELUMEN'], price: 3000 },
      { tasks: ['Tratamiento REPARADOR', 'secado'], price: 3500 }
  ]

  customers_attrs =
    [
      { name: 'Ben', surname: 'Dover', email: 'ben.dover@carpanta.com', phone: '600111222' },
      { name: 'Hermione', surname: 'Byrne', email: 'hermione.byrne@carpanta.com', phone: '600111222' },
      { name: 'Felix', surname: 'Burns', email: 'felix.burns@carpanta.com', phone: '600111222' },
      { name: 'Eden', surname: 'Davenport', email: 'eden.davenport@carpanta.com', phone: '600111222' },
      { name: 'Isabella', surname: 'Mckinney', email: 'isabella.mckinney@carpanta.com', phone: '600111222' },
      { name: 'Teresa', surname: 'Le', email: 'teresa.le@carpanta.com', phone: '600111222' },
      { name: 'Casey', surname: 'Salazar', email: 'casey.salazar@carpanta.com', phone: '600111222' },
      { name: 'Fatima', surname: 'Sanchez', email: 'fatima.sanchez@carpanta.com', phone: '600111222' },
      { name: 'Pearl', surname: 'Baxter', email: 'pearl.baxter@carpanta.com', phone: '600111222' },
      { name: 'Molly', surname: 'Barron', email: 'molly.barron@carpanta.com', phone: '600111222' }
  ]

  offers = offers_attrs.map do |offer_attrs|
    offer = Carpanta::Domain::Offers::Offer.build(offer_attrs)
    raise "Error building offer. Details: #{offer.errors.to_h}" unless offer.errors.empty?

    Carpanta::Domain::Offers::Repository.save!(offer)
    offer
  end

  customers = customers_attrs.map do |customer_attrs|
    Carpanta::Domain::Customers::Service.save!(customer_attrs)
  end

  create_appointment = lambda do |customer, offer|
    result = Carpanta::Commands::CreateAppointment.call(customer_id: customer.id, offer_id: offer.id, starting_at: Time.now, duration: rand(30..60))
    result.failure do |errors|
      raise "Error creating appointment. Details: #{errors}"
    end
  end

  customers.each do |customer|
    (1..10).each do
      create_appointment.call(customer, offers.sample)
    end
  end
end.call
