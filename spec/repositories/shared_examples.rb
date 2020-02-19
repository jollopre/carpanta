RSpec.shared_examples "repository creation" do
  it 'persists the entity' do
    result = described_class.create!(entity)

    expect(result).to be_an_instance_of(entity_class)
    expect(result.id).not_to be_nil
    expect(result.created_at).not_to be_nil
    expect(result.updated_at).not_to be_nil
  end
end
