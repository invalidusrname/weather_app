require 'rails_helper'

RSpec.describe "Weather", type: :request do
  describe "GET /index" do
    it "displays the form" do
      get "/weather/index"

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Get Forecast")
    end
  end

  describe "GET /forecast" do
    it "requires a zip code" do
      get "/weather/forecast"

      expect(flash[:error]).to eq("Invalid Zip Code")
      expect(response).to have_http_status(:redirect)
    end

    it "gets the weather" do
      VCR.use_cassette('weather/forecast_success') do
        get "/weather/forecast?zip=29732"

        expect(response).to have_http_status(:success)
      end
    end

    it "uses the cache for multiple requests" do
      cache_store = ActiveSupport::Cache::MemoryStore.new
      allow(Rails).to receive(:cache).and_return(cache_store)
      Rails.cache.clear

      VCR.use_cassette('weather/forecast_success') do
        get "/weather/forecast?zip=29732"

        expect(response).to have_http_status(:success)
      end

      get "/weather/forecast?zip=29732"

      expect(response).to have_http_status(:success)
      expect(response.body).to include("using cache")
    end

    it "fails to get the weather" do
      VCR.use_cassette('weather/forecast_failure') do
        get "/weather/forecast?zip=11111"

        expect(flash[:error]).to eq("Error fetching forecast")
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
