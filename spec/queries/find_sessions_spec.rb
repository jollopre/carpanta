require 'app/queries/find_sessions'

RSpec.describe Carpanta::Queries::FindSessions do
  describe '.call' do
    context 'when empty params are sent' do
      it 'returns all the sessions' do
        result = described_class.call

        expect(result.to_sql).to include('SELECT "sessions".* FROM "sessions"')
      end
    end

    context 'when params are sent' do
      let!(:a_customer) { FactoryBot.create(:customer, email: 'wadus@carpanta.com') }
      let!(:another_customer) { FactoryBot.create(:customer, email: 'another_wadus@carpanta.com')  }
      let!(:a_task) { FactoryBot.create(:task) }
      let!(:another_task) { FactoryBot.create(:task) }
      let!(:a_session) { FactoryBot.create(:session, customer_id: a_customer.id, task_id: a_task.id, price: 1500) }
      let!(:another_session) { FactoryBot.create(:session, customer_id: another_customer.id, task_id: another_task.id, price: 1600) }

      context 'with customer_id' do
        let(:params) { { customer_id: a_customer.id } }
        it 'filters by customer_id' do
          result = described_class.call(params)

          expect(result).to include(have_attributes(price: 1500, customer_id: a_customer.id, task_id: a_task.id))
          expect(result.size).to eq(1)
        end
      end

      context 'with task_id' do
        let(:params) { { task_id: a_task.id } }
        it 'filters by task_id' do
          result = described_class.call(params)

          expect(result).to include(have_attributes(price: 1500, customer_id: a_customer.id, task_id: a_task.id))
          expect(result.size).to eq(1)
        end
      end

      context 'with include task' do
        let(:params) { { include: :task } }
        it 'loads the tasks associated to each session' do
          result = described_class.call(params)

          expect(result).to include(have_attributes(task: have_attributes(id: a_task.id)))
          expect(result).to include(have_attributes(task: have_attributes(id: another_task.id)))
          expect(result.to_sql).to match(/SELECT.*"sessions"\."id".*"sessions"\."price".*"tasks"\."id".*"tasks"\."name"/)
          expect(result.to_sql).to include('INNER JOIN "tasks" ON "tasks"."id" = "sessions"."task_id"')
        end
      end
    end
  end
end
