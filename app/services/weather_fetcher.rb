
require "uri"
require "net/http"

class WeatherFetcher
  def self.fetch_forecast(zip, force: false)
    return { error: "Invalid Zip Code" } unless zip.to_s.match?(/^\d{5}$/)

    cache_key = "weather_forecast/#{zip}"
    cache_hit = true

    api_key = ENV["WEATHER_API_TOKEN"] || Rails.application.credentials.dig(:weather_api, :token)
    puts "WEATHER_API_TOKEN size: #{ENV["WEATHER_API_TOKEN"].to_s.length}"
    puts "CREDENTIAL TOKEN size: #{Rails.application.credentials.dig(:weather_api, :token)}"
    puts "API_KEY size: #{api_key.to_s.length}"

    forecast = Rails.cache.fetch(cache_key, expires_in: 30.minutes, force: force) do
      cache_hit = false
      params = { alerts: "no", aqi: "no", days: "5", key: api_key, q: zip }
      sorted_params = params.sort_by { |k, _| k.to_s }
      query = URI.encode_www_form(sorted_params)

      uri = URI("https://api.weatherapi.com/v1/forecast.json?#{query}")

      response = Net::HTTP.get_response(uri)

      if response.is_a? Net::HTTPSuccess
        parse_weather_data(JSON.parse(response.body))
      else
        Rails.logger.error "Unable to fetch weather: #{response.message}"
        nil
      end
    end

    if forecast.nil?
      { error: "Error fetching forecast" }
    else
      { forecast: forecast, cache_hit: cache_hit }
    end
  end

  def self.parse_weather_data(data)
    {
      location: data["location"]["name"],
      current_temp: data["current"]["temp_f"],
      forecast_days: data["forecast"]["forecastday"].map do |f|
        {
          date: f["date"],
          max_temp: f["day"]["maxtemp_f"],
          min_temp: f["day"]["mintemp_f"]
        }
      end
    }
  end
end
