require 'open-uri'
require 'json'

class ForecastsController < ApplicationController
  def location

    @address = params[:address].downcase

    url_safe_address = URI.encode(@address)

    url_of_data_we_want = "http://maps.googleapis.com/maps/api/geocode/json?address=" + url_safe_address
    raw_data = open(url_of_data_we_want).read
    parsed_data = JSON.parse(raw_data)

    @latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    url_of_weather_data = "https://api.forecast.io/forecast/cde2501b2b09bfe2cff0e52364691e70/" + @latitude.to_s + "," + @longitude.to_s
    raw_weather_data = open(url_of_weather_data).read
    @parsed_weather_data = JSON.parse(raw_weather_data)

    @temperature = @parsed_weather_data["currently"]["temperature"]
    @next_hour = @parsed_weather_data["minutely"]["summary"]
    @next_day = @parsed_weather_data["hourly"]["summary"]

    render 'location'
  end
end
