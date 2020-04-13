module Carpanta
  module Presenters
    class Customer
      attr_reader :customer, :sessions

      def initialize(customer:, sessions:)
        @customer = customer
        @sessions = sessions.map{ |session| SessionDelegator.new(session) }
      end

      def attributes
        { customer: customer, sessions: sessions }
      end
    end

    class SessionDelegator < SimpleDelegator
      def formatted_price
        Money.new(source.price).format(symbol_position: :after)
      end

      private

      def source
        __getobj__
      end
    end
  end
end
