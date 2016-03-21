require 'cinch'
require_relative 'plugins/plugin_manager'

cinch = Cinch::Bot.new do
  configure do |config|
    config.server     = "irc.freenode.org"
    config.port       = 6667
    config.ssl.use    = false
    config.ssl.verify = false
    config.channels = ["#tehspede"]
    config.nick     = "SickGear-dev"
    config.user     = "SickGear"
    config.plugins.plugins = [PluginManager]
  end
end

cinch.start