require 'app/repositories/session'

module Carpanta
  module Queries
    class FindSessions
      def initialize(relation = Carpanta::Repositories::Session.all)
        @relation = relation
      end

      def call(params = {})
        @relation = @relation.where(customer_id: params[:customer_id]) if params[:customer_id]
        @relation = @relation.where(task_id: params[:task_id]) if params[:task_id]

        @relation
      end

      class << self
        def call(params = {})
          new.call(params)
        end
      end
    end
  end
end
