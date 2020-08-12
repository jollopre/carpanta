require_relative 'provisioner/shared_examples'

RSpec.describe Provisioner do
  it 'has a version' do
    expect(described_class::VERSION).not_to be_nil
  end

  it_behaves_like 'configurable object'
  it_behaves_like 'loggable object'
end
