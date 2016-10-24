require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    url1 = 'http://maps.googleapis.com/maps/api/geocode/json?address='+ @street_address_without_spaces

    raw_data_geo = open(url1).read
    parsed_data_geo = JSON.parse(raw_data_geo)

    @latitude = parsed_data_geo["results"][0]["geometry"]["location"]["lat"]
    @longitude =  parsed_data_geo["results"][0]["geometry"]["location"]["lng"]

    url2 ="https://api.darksky.net/forecast/016fad19cb3ef247a6daaa458cce300f/#{@latitude},#{@longitude}"

    raw_data_temp = open(url2).read
    parsed_data_temp = JSON.parse(raw_data_temp)

    @current_temperature = parsed_data_temp["currently"]["temperature"]

    @current_summary = parsed_data_temp["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_temp["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data_temp["hourly"]["summary"]

    @summary_of_next_several_days =  parsed_data_temp["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
