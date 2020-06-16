RSpec.shared_examples 'configurable object' do
  it 'responds to configure' do
    expect(subject).to respond_to(:configure)
  end

  it 'responds to configuration' do
    expect(subject).to respond_to(:configuration)
  end
end
