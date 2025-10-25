require 'rails_helper'

describe "WeatherFetcher" do
  describe "fetch_forecast" do
    it "fetches the forecast" do
      VCR.use_cassette('weather/forecast_success') do
       result = WeatherFetcher.fetch_forecast('29732')

       expected = {
         forecast: {
           location: "Rock Hill",
           current_temp: 69.8,
           forecast_days: [
             { date: "2025-10-03", max_temp: 80.8, min_temp: 51.4 },
             { date: "2025-10-04", max_temp: 74.7, min_temp: 57.4 },
             { date: "2025-10-05", max_temp: 77.7, min_temp: 64.9 },
             { date: "2025-10-06", max_temp: 77.8, min_temp: 61.5 },
             { date: "2025-10-07", max_temp: 82.6, min_temp: 62.4 }
           ]
         },
         cache_hit: false
       }

       expect(result.merge(forecast: result[:forecast].to_h)).to eq(expected)
     end
    end

    it "caches calls with the same zip" do
      cache_store = ActiveSupport::Cache::MemoryStore.new
      allow(Rails).to receive(:cache).and_return(cache_store)
      Rails.cache.clear

      VCR.use_cassette('weather/forecast_success') do
        _first_call = WeatherFetcher.fetch_forecast('29732')
      end

      result = WeatherFetcher.fetch_forecast('29732')

      expect(result[:cache_hit]).to be(true)
    end

    it "fails with Service Unavailable" do
      allow(Net::HTTP).to receive(:get_response).and_raise(StandardError)
      result = WeatherFetcher.fetch_forecast('11111')

      expect(result[:error]).to eq("Forecast unavailable")
    end

    it "fails to fetch the forecast" do
      VCR.use_cassette('weather/forecast_failure') do
        result = WeatherFetcher.fetch_forecast('11111')

        expect(result[:error]).to eq("Error fetching forecast")
      end
    end

    it "will not fetch the forecast for an invalid zipcode" do
      result = WeatherFetcher.fetch_forecast('invalid')

      expect(result[:error]).to eq("Invalid Zip Code")
    end
  end
end
