require 'dry-validation'

module Deploy
  module Schemas
    class CreateCluster < Dry::Validation::Contract
      schema do
        optional(:cluster_name).filled(:string)
      end
    end
  end
end
