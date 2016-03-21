require 'cinch'
require 'nokogiri'
require 'open-uri'
require_relative '../config'

class Tvdb
  include Cinch::Plugin
  attr_accessor :query
  match /tv (.+)/

  set :help, <<-HELP
    "!tv <show>" return searched show information from tvdb.com
  HELP

  def id
    tvdb_id_search_url = 'http://thetvdb.com/api/GetSeries.php?seriesname='
    url = URI::encode(tvdb_id_search_url + @query)
    Nokogiri::XML(open(url)).css('id').text
  end

  def get_url
    url = "http://thetvdb.com/api/#{TVDB_APIKEY}/series/#{id}/all/en.xml"
    @xml = Nokogiri::XML(open(url))
    url
  end

  def name
    @xml.css('SeriesName').text
  end

  def network
    @xml.css('Network').text
  end

  def status
    @xml.css('Status').text
  end

  def execute(m, query)
    @query = query
    get_url
    m.reply("Show: #{name} :: Network: #{network} :: Status: #{status}")
  end
end