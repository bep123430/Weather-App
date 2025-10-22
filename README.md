# README

This is a basic weather application written in Ruby on Rails. It pulls current and future weather data from https://www.weatherapi.com/ and parses that data to show current weather information as well as the forecast for the following 6 days.

## Project Structure
The backend of this project is composed of a [WeatherController](app/controllers/weather_controller.rb), a [WeatherRetrievalService](app/services/weather_retrieval_service.rb), and a [WeatherResults](app/models/weather_results.rb) object. When an existing zip code is passed into the route `/weather/:zip`, the #index endpoint returns a WeatherResults object that is populated with the weather results for the given zip. These weather results are then rendered in a [simple ERB frontend file](app/views/weather/index.html.erb). 

This project includes basic rspec testing, including API mocking using Webmock. 

## Setup

1. Clone this repository using `git clone git@github.com:BlythePollard/Weather-App.git`
2. Install Ruby and Ruby on Rails. This project uses Ruby on Rails version 8.0.3 and Ruby version 3.2.2. 
3. Install dependencies with `bundle install`
4. Run `rails db:migrate`
4. Set up an account at [https://www.weatherapi.com/](https://www.weatherapi.com/) and add the API key to the `WEATHERAPI_API_KEY` env var in the .env file.
5. Run the server using `rails s`. Endpoint is available at `http://localhost:3000/weather/:zip`

## Testing

Run `rspec spec` to test full suite.

## Next Steps
Next steps to improve this application would be:
1. Create an improved UI. The UI is very simple and not visually appealing- a lot of work would need to be done here in order to make this application user-friendly.
2. Add logging in the app for better visibility into potential issues.
3. Add more data to the experience. For example, a user could receive more in-depth weather notifications for severe weather.
3. Add user authentication and interaction. It would be great for a user to personalize their experience.
4. Improve testing. The tests are simple and test only a happy path and a sad path.
5. Add a pre-commit linting hook. Rubocop is run when pushed to Github, but it would be great to catch syntax errors before pushing code.
