RSpec.shared_examples 'successful' do
  it 'does not contain errors' do
    result = subject.call(default_params)

    expect(result.errors.to_h).to be_empty
    expect(result.success?).to eq(true)
  end
end

RSpec.shared_examples 'must be a string' do |params, key|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('must be a string')
      )
    end
  end
end

RSpec.shared_examples 'must be an integer' do |params, key|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('must be an integer')
      )
    end
  end
end

RSpec.shared_examples 'must be an array' do |params, key|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('must be an array')
      )
    end
  end
end

RSpec.shared_examples 'is in invalid format' do |params, key|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('is in invalid format')
      )
    end
  end
end
