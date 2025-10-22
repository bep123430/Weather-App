require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherRetrievalService, type: :service do
  it "should return a weather results object" do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{ENV['WEATHERAPI_API_KEY']}&q=80219&days=7").
      to_return(status: 200, body: File.read('spec/fixtures/mock_weather_response.json'), headers: { 'Content-Type' => 'application/json' })
    weather_retrieval_service = WeatherRetrievalService.new("80219")
    weather_results = weather_retrieval_service.get_full_weather_data

    expect(weather_results).to be_a(WeatherResults)
    expect(weather_results.zipcode).to eq("80219")
    expect(weather_results.current_weather_data).to eq({ current_temp: 66.6, current_condition: "Sunny", current_feels_like: 66.6 })
    expect(weather_results.forecast_data.length).to eq(5)
  end

  it "should return an error code if the request is unsuccessful" do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{ENV['WEATHERAPI_API_KEY']}&q=80219&days=7").
      to_return(status: 400, body: 'sad', headers: { 'Content-Type' => 'application/json' })

    weather_retrieval_service = WeatherRetrievalService.new("80219")
    expect { weather_retrieval_service.get_full_weather_data }.to raise_error(WeatherServiceError, "Received HTTP 400")
  end
end
