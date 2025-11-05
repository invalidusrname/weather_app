require Rails.root.join("app", "services", "weather_fetcher")

WeatherFetcher.configure do |config|
  config.provider = ENV["WEATHER_PROVIDER"] || Rails.application.credentials.dig(:weather_api, :provider) || "weather_api"
  config.api_key =  ENV["WEATHER_API_TOKEN"] || Rails.application.credentials.dig(:weather_api, :token)

  puts "WeatherFetcher.configure"
  puts "PROVIDER: #{config.provider}"
  puts "TOKEN length: #{config.api_key.to_s.length}"
end
