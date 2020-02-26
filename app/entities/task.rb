module Carpanta
  module Entities
    class Task
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :description, :price, :created_at, :updated_at
      validates_presence_of :name, :price
      validates_numericality_of :price, only_integer: true

      def attributes
        { id: id, name: name, description: description, price: price, created_at: created_at, updated_at: updated_at }
      end
    end
  end
end
