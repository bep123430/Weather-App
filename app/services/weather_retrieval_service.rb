class WeatherServiceError < StandardError
end

class WeatherRetrievalService
  API_KEY = ENV["WEATHERAPI_API_KEY"]
  BASE_URL = "http://api.weatherapi.com/v1/forecast.json"

  def initialize(zipcode, errors = [])
    @zipcode = zipcode
  end

  def get_full_weather_data
    data_cached = true

    weather_data = Rails.cache.fetch("weather_#{@zipcode}", expires_in: 30.minutes) do
      data_cached = false
      response = HTTParty.get("#{BASE_URL}?key=#{API_KEY}&q=#{@zipcode}&days=7")
      if response.success?
        current_weather_data = extract_current_weather_data(response)
        forecast_weather_data = extract_forecast_weather_data(response)
        { current_weather_data: current_weather_data, forecast_weather_data: forecast_weather_data }
      else
        raise WeatherServiceError, "Received HTTP #{response.code}"
      end
    end
      WeatherResults.new(@zipcode, weather_data[:current_weather_data], weather_data[:forecast_weather_data], data_cached)
  end

  private

  def extract_current_weather_data(weather_data)
    current_temp = weather_data["current"]["temp_f"]
    current_condition = weather_data["current"]["condition"]["text"]
    current_feels_like = weather_data["current"]["feelslike_f"]
    if current_temp.nil? || current_condition.nil? || current_feels_like.nil?
      raise WeatherServiceError, "Error: Invalid weather data- current_temp: #{current_temp}, current_condition: #{current_condition}, current_feels_like: #{current_feels_like}"
    else
      {
        current_temp: current_temp,
        current_condition: current_condition,
        current_feels_like: current_feels_like
      }
    end
  end

  def extract_forecast_weather_data(weather_data)
    future_days = weather_data["forecast"]["forecastday"]
    # Remove today's date, as this will be displayed as the current weather
    future_days.shift
    forecast_data = future_days.map do |day|
      {
        date: day["date"],
        max_temp: day["day"]["maxtemp_f"],
        min_temp: day["day"]["mintemp_f"],
        condition: day["day"]["condition"]["text"]
      }
    end
    if forecast_data.nil?
      raise WeatherServiceError, "Error: Invalid forecast data- forecast_data: #{forecast_data}"
    else
      forecast_data
    end
  end

  def parse_weather_data(weather_data)
    JSON.parse(weather_data)
  end
end
