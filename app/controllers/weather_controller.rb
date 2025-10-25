class WeatherController < ApplicationController
  rate_limit to: 10, within: 1.minute, only: :forecast, with: :too_many_requests

  def index
  end

  def forecast
    zip = forecast_params[:zip]
    force = forecast_params[:force] == "1"
    result = WeatherFetcher.fetch_forecast(zip, force: force)

    if result[:error]
      handle_error(result[:error], zip)
    else
      handle_success(result, zip, force)
    end
  rescue StandardError => e
    Rails.logger.error("Forecast error: #{e.message}")
    handle_error("An unexpected error occurred", zip)
  end


  def too_many_requests
    handle_error("Too many requests. Wait a little bit before trying again")
  end

  private

    def forecast_params
      params.permit(:zip, :force)
    end

    def handle_error(error_message = "", zip = "")
      flash[:error] = error_message

      respond_to do |format|
        format.html { redirect_to root_path }
      end
    end

    def handle_success(result, zip, force)
      forecast = result[:forecast]
      cache_hit = result[:cache_hit]

      respond_to do |format|
        format.html { render :forecast, locals: { forecast:, cache_hit:, zip: } }
      end
    end
end
