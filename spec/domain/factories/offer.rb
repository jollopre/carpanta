require 'domain/offers/offer'

FactoryBot.define do
  factory :offer, class: Carpanta::Domain::Offers::Offer do
    tasks { ['Cutting with scissor', 'Shampooing'] }
    price { 2200 }

    initialize_with do
      Carpanta::Domain::Offers::Offer.build(attributes)
    end
  end
end
