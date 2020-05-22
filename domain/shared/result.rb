module Carpanta
  module Domain
    module Shared
      module Result
        def success(value)
          result = ResultClass.new
          result.success = value

          result
        end

        def failure(value)
          result = ResultClass.new
          result.failure = value

          result
        end
      end

      class ResultClass
        def initialize
          @success = nil
          @failure = nil
        end

        def success=(value)
          @failure = nil
          @success = value
        end

        def failure=(value)
          @success = nil
          @failure = value
        end

        def success
          return unless block_given?

          yield(@success) if @success.present?
        end

        def failure
          return unless block_given?

          yield(@failure) if @failure.present?
        end
      end
    end
  end
end
