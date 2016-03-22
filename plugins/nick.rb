require 'cinch/plugin'
require_relative '../config'

class Nick
  include Cinch::Plugin

  match /nick (.+)/

  def execute(m, nick)
    if ADMINS.include?(m.user.nick)
      @bot.nick = nick
    end
  end
end