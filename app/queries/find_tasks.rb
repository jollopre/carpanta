require 'app/repositories/task'
require 'app/entities/task'

module Carpanta
  module Queries
    class FindTasks
      def initialize(relation = Carpanta::Repositories::Task.all)
        @relation = relation
      end

      def call(params = {})
        @relation = @relation.where(id: params[:id]) if params[:id]

        reconstitute
      end

      private

      def reconstitute
        @relation.map do |task|
          Entities::Task.new(task.attributes)
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
