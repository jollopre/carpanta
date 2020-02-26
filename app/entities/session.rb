module Carpanta
  module Entities
    class Session
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :price, :created_at, :updated_at, :customer_id, :task_id
      validates_presence_of :price, :customer_id, :task_id
      validates_numericality_of :price, :customer_id, :task_id

       def attributes
         { id: id, price: price, created_at: created_at, updated_at: updated_at, customer_id: customer_id, task_id: task_id }
       end
    end
  end
end
