require 'domain/offers/offer_legacy'
require 'domain/offers/repository_legacy'

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
end
