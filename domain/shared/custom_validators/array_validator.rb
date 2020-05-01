module Carpanta
  module Domain
    module Shared
      module CustomValidators
        class ArrayValidator < ActiveModel::EachValidator
          def validate_each(record, attr_name, value)
            unless value.is_a?(Array)
              record.errors.add(attr_name, :not_an_array, value: value)
              return
            end
            check_only_string(record, attr_name, value) if only_string?
          end

          private

          def only_string?
            options[:only_string] == true
          end

          def check_only_string(record, attr_name, value)
            value.each_with_index do |element, index|
              unless element.is_a?(String)
                record.errors.add(attr_name, :not_a_string, index: index, value: element)
              end
            end
          end
        end
      end
    end
  end
end
