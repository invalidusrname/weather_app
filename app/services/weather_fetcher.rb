
require "uri"
require "net/http"

require_relative "weather/config"

class WeatherFetcher
  @@config = Weather::Config.new

  def self.config
    @@config
  end

  def self.configure
    yield(config) if block_given?
  end

  def self.fetch_forecast(zip, force: false)
    return { error: "Invalid Zip Code" } unless zip.to_s.match?(/^\d{5}$/)

    klass = Weather::Providers.provider_class_for(config.provider)

    provider = klass.new(config.api_key)

    cache_key = "weather_forecast/#{provider.provider_name}/#{zip}"
    cache_hit = true

    forecast = Rails.cache.fetch(cache_key, expires_in: 30.minutes, force: force) do
      cache_hit = false
      begin
        forecast = provider.query(zip)
      rescue StandardError => e
        Rails.logger.error "Forecast fetch exception for #{provider.provider_name}: #{e.message}"
        nil
      end
    end

    if forecast.nil?
      { error: "Error fetching forecast" }
    else
      { forecast: forecast, cache_hit: cache_hit }
    end
  end
end
