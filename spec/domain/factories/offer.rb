require 'domain/offers/offer_legacy'
require 'domain/offers/repository_legacy'
require 'domain/offers/offer'

FactoryBot.define do
  factory :offer_legacy, class: Carpanta::Domain::Offers::OfferLegacy do
    tasks { ['Cutting with scissor', 'Shampooing'] }
    price { 2200 }

    initialize_with do
      Carpanta::Domain::Offers::OfferLegacy.build(attributes)
    end

    to_create do |instance|
      Carpanta::Domain::Offers::RepositoryLegacy.save!(instance)
    end
  end

  factory :offer, class: Carpanta::Domain::Offers::Offer do
    tasks { ['Cutting with scissor', 'Shampooing'] }
    price { 2200 }

    initialize_with do
      Carpanta::Domain::Offers::Offer.new(attributes)
    end
  end
end
