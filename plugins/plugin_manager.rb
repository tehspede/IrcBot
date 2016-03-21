require 'cinch'
require_relative '../config'
class PluginManager
  include Cinch::Plugin

  attr_accessor :query

  set :help, <<-HELP
    "!plugin <reload/load/disable> <plugin>"
  HELP

  match(/plugin reload (.+)/, method: :reload)
  match(/plugin load (.+)/, method: :enable)
  match(/plugin enable (.+)/, method: :enable)
  match(/plugin disable (.+)/, method: :disable)

  def authorized?(m, &block)
    (ADMINS.include?(m.user.nick)) ? (instance_eval(&block)) : (m.reply 'You don\'t have permission to use this command!')
  end

  def enable_plugin(m, query)
    plugin = query.downcase.split('_').map {|w| w.capitalize}.join
    file = ROOT_DIR + 'plugins/' + query.downcase + '.rb'

    begin
      load(file)
    rescue LoadError
      m.reply "File #{query.downcase}.rb does not exist!"
      return false
    end

    @bot.plugins.register_plugin(Cinch::Plugin.const_get(plugin))
    true
  end

  def enable(m, query)
    authorized? m do
      if enable_plugin(m, query)
        m.reply "Successfully loaded #{query}"
      end
    end
  end

  def disable_plugin(m, query)
    class_name = query.downcase.split('_').map {|w| w.capitalize}.join

    begin
      plugin = Cinch::Plugin.const_get(class_name)
      @bot.plugins.select {|p| p.class == plugin}.each do |p|
        @bot.plugins.unregister_plugin(p)
      end
    rescue NameError
      m.reply "No plugin named #{class_name} to disable!"
      return false
    end

    true
  end

  def disable(m, query)
    authorized? m do
      if disable_plugin(m, query)
        m.reply "Successfully disabled #{query}"
      end
    end
  end

  def reload(m, query)
    authorized? m do
      disable_plugin(m, query)
      enable_plugin(m, query)
      m.reply "Successfully reloaded #{query}"
    end
  end
end