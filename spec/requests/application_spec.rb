require_relative "shared_context"

RSpec.describe Carpanta::Controllers::Application do
  include_context "requests"

  describe "GET /" do
    it "returns 302" do
      get "/"

      expect(last_response.status).to eq(302)
    end

    it "redirects to /customers" do
      get "/"

      expect(last_response.headers).to include("Location" => /\/customers$/)
    end
  end
end
