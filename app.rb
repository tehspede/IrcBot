require 'cinch'
require_relative 'plugins/plugin_manager'
require_relative 'migrations/initial'

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
    config.plugins.plugins = [PluginManager]
  end
end

cinch.start