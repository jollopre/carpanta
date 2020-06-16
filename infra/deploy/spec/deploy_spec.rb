require_relative 'deploy/shared_examples'

RSpec.describe Deploy do
  it 'has a version' do
    expect(described_class::VERSION).not_to be_nil
  end

  it_behaves_like 'configurable object'
end
