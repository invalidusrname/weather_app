class WeatherController < ApplicationController
  def index
  end

  def forecast
    zip = params[:zip]
    force = params[:force] == "1"

    result = WeatherFetcher.fetch_forecast(zip, force: force)

    if result[:error]
      flash[:error] = result[:error]
      redirect_to weather_index_path
      return
    end

    @forecast = result[:forecast]
    @cache_hit = result[:cache_hit]
  end
end
