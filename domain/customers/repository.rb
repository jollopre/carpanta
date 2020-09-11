module Carpanta
  module Domain
    module Customers
      class Repository
        # class method to accommodate operations against ActiveRecord ORM. None of the methods described belong can raise an Exception, therefore we need to use Monads.
        class << self
          def save(customer)
            # Infra::ORM::Customer#save
          end

          def exists?(conditions = :none)
            # Infra::ORM::Customer.exits?(id: id)
          end

          def find_by_id(id)
            # Infra::ORM::Customer.find_by(id: id)
          end
        end
      end
    end
  end
end
