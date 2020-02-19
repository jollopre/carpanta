module Carpanta
  module Entities
    class Task
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :description, :price, :created_at, :updated_at
      validates_presence_of :name, :price
      validates_numericality_of :price, only_integer: true

      def attributes
        { id: nil, name: nil, description: nil, price: nil, created_at: nil, updated_at: nil }
      end
    end
  end
end
