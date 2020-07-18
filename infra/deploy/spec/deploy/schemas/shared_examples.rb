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

RSpec.shared_examples 'must be a hash' do |params, key|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('must be a hash')
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

RSpec.shared_examples 'must be one of' do |params, key, included_in|
  context "when `#{params[key]}` is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include("must be one of: #{included_in.join(', ')}")
      )
    end
  end
end

RSpec.shared_examples 'is not allowed' do |params, key|
  context "when `#{key}` key is received" do
    it 'result failed' do
      result = subject.call(default_params.merge(params))

      expect(result.failure?).to eq(true)
    end

    it 'errors include message' do
      result = subject.call(default_params.merge(params))

      expect(result.errors.to_h).to include(
        key => include('is not allowed')
      )
    end
  end
end

RSpec.shared_examples 'successful' do
  it 'does not contain errors' do
    result = subject.call(default_params)

    expect(result.errors.to_h).to be_empty
    expect(result.success?).to eq(true)
  end
end
