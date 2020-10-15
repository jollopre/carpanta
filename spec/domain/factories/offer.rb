require 'domain/offers/offer'
require 'domain/offers/repository'

FactoryBot.define do
  factory :offer, class: Carpanta::Domain::Offers::Offer do
    tasks { ['Cutting with scissor', 'Shampooing'] }
    price { 2200 }

    initialize_with do
      Carpanta::Domain::Offers::Offer.new(attributes)
    end

    to_create do |instance|
      repository = Carpanta::Domain::Offers::Repository.new
      repository.save(instance).value!
    end
  end
end
