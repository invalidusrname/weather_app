require 'rails_helper'

RSpec.describe "Versions", type: :request do
  describe "GET /show" do
    it "does not know the version" do
      get "/version/show"

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "version" => "unknown" })
    end

    it "knows the version" do
      allow(ENV).to receive(:[]).with('GIT_SHA').and_return('lol123')

      get "/version/show"

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "version" => "lol123" })
    end
  end
end
