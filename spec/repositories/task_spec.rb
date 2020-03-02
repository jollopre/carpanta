require 'app/repositories/task'
require 'app/entities/task'
require_relative 'shared_examples'

RSpec.describe Carpanta::Repositories::Task do
  describe '.create!' do
    let(:entity) do
      FactoryBot.build(:task)
    end
    let(:entity_class) do
      Carpanta::Entities::Task
    end

    it_behaves_like 'repository creation'
  end
end
