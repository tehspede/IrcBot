require 'cinch'
require_relative 'plugins/plugin_manager'

cinch = Cinch::Bot.new do
  configure do |config|
    config.server     = SERVER
    config.port       = PORT
    config.ssl.use    = false
    config.ssl.verify = false
    config.channels = CHANNELS
    config.nick     = NICK
    config.user     = "SickGear"
    config.plugins.plugins = [PluginManager]
  end
end

cinch.start