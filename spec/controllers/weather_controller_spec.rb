require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherController, type: :controller do
  before(:each) do
  stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{ENV['WEATHERAPI_API_KEY']}&q=80223&days=7").
    to_return(status: 200, body: File.read('spec/fixtures/mock_weather_response.json'), headers: { 'Content-Type' => 'application/json' })
  @mock_service = instance_double(WeatherRetrievalService)
  end

  describe "GET #index" do
  it "returns a success response when zipcode is provided" do
    get :index, params: { zip: "80223" }
    expect(response).to be_successful
  end

    it "returns an error when the weather retrieval service returns an error" do
      allow_any_instance_of(WeatherRetrievalService).to receive(:get_full_weather_data).and_raise(WeatherServiceError)
      get :index, params: { zip: "80223" }
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
