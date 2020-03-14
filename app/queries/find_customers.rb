require 'app/repositories/customer'
require 'app/entities/customer'

module Carpanta
  module Queries
    class FindCustomers
      def initialize(relation = Carpanta::Repositories::Customer.all)
        @relation = relation
      end

      def call(params = {})
        @relation = @relation.where(id: params[:id]) if params[:id]

        reconstitute
      end

      private

      def reconstitute
        @relation.map do |customer|
          Entities::Customer.new(customer.attributes)
        end
      end

      class << self
        def call(params = {})
          new.call(params)
        end
      end
    end
  end
end
