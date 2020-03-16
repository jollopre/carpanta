require 'app/repositories/session'
require 'app/entities/session'
require 'app/entities/task'

module Carpanta
  module Queries
    class FindSessions
      def initialize(relation = Carpanta::Repositories::Session.all)
        @relation = relation
      end

      def call(params = {})
        scope(params)
        reconstitute
      end

      def scope(params = {})
        @relation = @relation.where(customer_id: params[:customer_id]) if params[:customer_id]
        @relation = @relation.where(task_id: params[:task_id]) if params[:task_id]
        @relation = @relation.joins(:task).includes(:task) if params[:include] == :task
        @relation = @relation.order(created_at: :desc)

        @relation
      end

      private

      def reconstitute
        @relation.map do |session|
          Entities::Session.new(session.attributes.merge(task: Entities::Task.new(session.task.attributes)))
        end
      end

      class << self
        def call(params = {})
          new.call(params)
        end

        def scope(params = {})
          new.scope(params)
        end
      end
    end
  end
end
