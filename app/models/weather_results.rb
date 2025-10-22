class WeatherResults
  attr_reader :zipcode, :current_weather_data, :forecast_data, :cached

  def initialize(zipcode, current_weather_data, forecast_data, cached)
    @zipcode = zipcode
    @current_weather_data = current_weather_data
    @forecast_data = forecast_data
    @cached = cached
  end
end
