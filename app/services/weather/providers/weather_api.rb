module Weather
  module Providers
    class WeatherApi < Base
      API_BASE = "https://api.weatherapi.com/v1/forecast.json"

      def query(zip)
        uri = build_uri(zip)
        response = Net::HTTP.get_response(uri)

        if response.is_a? Net::HTTPSuccess
          data = JSON.parse(response.body)
          convert_to_forecast(data)
        else
          Rails.logger.error "Unable to fetch weather from #{provider_name}: #{response.message}"

          nil
        end
      end

      def build_uri(zip)
        params = { alerts: "no", aqi: "no", days: "5", key: api_key, q: zip }
        query = URI.encode_www_form(params)
        URI("#{API_BASE}?#{query}")
      end

      def convert_to_forecast(data)
        Weather::Forecast.new(
          location: data["location"]["name"],
          current_temp: data["current"]["temp_f"],
          forecast_days: data["forecast"]["forecastday"].map do |f|
            {
              date:     f["date"],
              max_temp: f["day"]["maxtemp_f"],
              min_temp: f["day"]["mintemp_f"]
            }
          end
        )
      end
    end
  end
end
