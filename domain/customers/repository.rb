require 'infra/orm'
require 'domain/shared/resultable'

module Carpanta
  module Domain
    module Customers
      class Repository
        class << self
          include Domain::Shared::Resultable

          def save(customer)
            Infra::ORM::Customer.new({
              id: customer.id,
              name: customer.name,
              surname: customer.surname,
              email: customer.email,
              phone: customer.phone
            }).save!
            Success(true)
          rescue => e
            Failure(message: e.message, backtrace: e.backtrace)
          end

          def exists?(conditions = :none)
            Success(Infra::ORM::Customer.exists?(conditions))
          end

          def find_by_id(id)
            # Infra::ORM::Customer.find_by(id: id)
          end
        end
      end
    end
  end
end
