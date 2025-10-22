require 'rails_helper'

RSpec.describe WeatherResults, type: :model do
  it "should have a zipcode, current_weather_data, and forecast_data" do
    weather_results = WeatherResults.new("80223", 65, "all the forecast data", false)
    expect(weather_results.zipcode).to eq("80223")
    expect(weather_results.current_weather_data).to eq(65)
    expect(weather_results.forecast_data).to eq("all the forecast data")
    expect(weather_results.cached).to eq(false)
  end
end
