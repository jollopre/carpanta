module Carpanta
  module Entities
    class Customer
      EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :surname, :email, :phone, :created_at, :updated_at

      validates :email, format: { with: EMAIL_REGEX }

      def attributes
        { id: nil, name: nil, surname: nil, email: nil, phone: nil, created_at: nil, updated_at: nil }
      end
    end
  end
end
