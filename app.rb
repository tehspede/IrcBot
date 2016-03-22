require 'cinch'
require_relative 'plugins/plugin_manager'
require_relative 'plugins/ban'
require_relative 'plugins/nick'
require_relative 'plugins/topic'
require_relative 'plugins/tvdb'
require_relative 'plugins/weather'
require_relative 'migrations/initial'
require 'cinch/plugins/identify'

if !File.exist?('db/weather.db')
  InitialMigration.migrate(:up)
end

cinch = Cinch::Bot.new do
  configure do |config|
    config.server     = SERVER
    config.port       = PORT
    config.ssl.use    = false
    config.ssl.verify = false
    config.channels = CHANNELS
    config.nick     = NICK
    config.user     = "SickGear"
    config.plugins.plugins = [Cinch::Plugins::Identify, PluginManager, Tvdb, Ban, Nick, Topic, Weather]
    config.plugins.options[Cinch::Plugins::Identify] = {
        :password => NSPASS,
        :type     => :nickserv,
    }
  end
end

cinch.start