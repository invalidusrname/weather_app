require Rails.root.join("app", "services", "weather_fetcher")

WeatherFetcher.configure do |config|
  config.provider =  ENV["WEATHER_PROVIDER"] || Rails.application.credentials.dig(:weather_api, :provider)
  config.api_key =  ENV["WEATHER_API_TOKEN"] || Rails.application.credentials.dig(:weather_api, :token)
end
