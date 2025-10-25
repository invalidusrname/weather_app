module Weather
  class Forecast
    attr_reader :location, :current_temp, :forecast_days

    def initialize(location:, current_temp:, forecast_days:)
      @location = location
      @current_temp = current_temp
      @forecast_days = forecast_days.map { |day_data| ForecastDay.new(**day_data) }
    end

    def to_h
      {
        location: location,
        current_temp: current_temp,
        forecast_days: forecast_days.map(&:to_h)
      }
    end


    class ForecastDay
      attr_reader :date, :max_temp, :min_temp

      def initialize(date:, max_temp:, min_temp:)
        @date = date
        @max_temp = max_temp
        @min_temp = min_temp
      end

      def to_h
        {
          date: date,
          max_temp: max_temp,
          min_temp: min_temp
        }
      end
    end
  end
end
