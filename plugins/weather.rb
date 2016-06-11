require_relative '../models/weather_command'
require 'nokogiri'
require 'cgi'
require 'open-uri'
require 'json'
require 'cinch'

class Weather
  include Cinch::Plugin

  match(/weather/, method: :weather)

  def last(user)
    location = WeatherCommand.where(user: user)
    location == [] ? false : location.last[:location]
  end

  def parse_xml(xml)
    @city = xml.xpath('//city/@name')
    @country = xml.xpath('//city/country').text
    @temperature = xml.xpath('//temperature/@value')
    @max = xml.xpath('//temperature/@max')
    @min = xml.xpath('//temperature/@min')
    @weather = xml.xpath('//weather/@value')
    @windspeed = xml.xpath('//wind/speed/@value')
  end

  def save_location(user, location)
    WeatherCommand.where(user: user).delete_all
    WeatherCommand.create(user: user, location: location, timestamp: Time.now)
  end

  def weather(m)
    query = (/\s([\d|\w]+)/).match(m.message)
    user = m.user.nick

    if query == nil
      location = last(user)
      if !location
        m.reply 'You have not used the weather command before with that nick! Please use "!weather <location>"'
        return
      end
    else
      location = query[1]
    end

    url = "http://api.openweathermap.org/data/2.5/weather?q=#{CGI.escape(location)}&units=metric&appid=6432b168f4a5b1e19241a833d5e00449"

    save_location(user, location)

    xml = Nokogiri::XML(URI.parse(url + '&mode=xml').open)
    parse_xml(xml)

    if !(@city.any?)
      m.reply 'No city was found with that location!'
      return
    end

    p @city

    m.reply "WEATHER - #{@city}, #{@country} :: Current #{@temperature}C, #{@weather}, Wind Speed: #{@windspeed} m/s :: Max: #{@max}C - Min: #{@min}C"
  end
end
