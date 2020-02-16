module Carpanta
  module Services
    module Sessions
      class Model
        include ActiveModel::Model
        include ActiveModel::Serialization

        attr_accessor :id, :price, :created_at, :updated_at, :customer_id, :task_id
        validates_presence_of :price, :customer_id, :task_id
        validates_numericality_of :price, :customer_id, :task_id

        def attributes
          { id: nil, price: nil, created_at: nil, updated_at: nil, customer_id: nil, task_id: nil }
        end
      end
    end
  end
end
