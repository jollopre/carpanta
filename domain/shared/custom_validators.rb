require_relative 'custom_validators/array_validator'

module Carpanta
  module Domain
    module Shared
      module CustomValidators
        def validates_array_of(*args)
          options = args.extract_options!.symbolize_keys
          options[:attributes] = args.flatten

          validates_with(ArrayValidator, options)
        end
      end
    end
  end
end
