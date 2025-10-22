class WeatherController < ApplicationController
  def index
    zipcode = params[:zip]
    begin
      @weather = WeatherRetrievalService.new(zipcode).get_full_weather_data
      render :index # Render weather data if successful
    rescue WeatherServiceError => e
      render json: { error: "An error occurred while fetching the weather data." }, status: :internal_server_error
    end
  end
end
