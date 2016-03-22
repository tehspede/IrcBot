require 'cinch/plugin'
require_relative '../config'

class Ban
  include Cinch::Plugin

  match /ban (.+)/, method: :ban
  match /unban (.+)/, method: :unban

  def parse_channel(m, query)
    channel = Regexp.new('^(#\S+)\s', true).match(query)
    if channel.nil?
      m.reply 'No channel could be parsed! Please use the format "!ban <channel> <user> <reason>"'
      false
    elsif !@bot.channels.include?(channel[1])
      m.reply "I am not in that channel #{channel}"
      false
    else
      channel[1]
    end
  end

  def parse_user(m, query)
    user = Regexp.new('^#\S+\s(\S+)\s', true).match(query)
    p user
    if user.nil?
      m.reply 'No user could be parsed! Please use the format "!ban <channel> <user> <reason>"'
      false
    elsif !Channel(@channel).has_user?(user[1])
      m.reply "No user could named #{user[1]} could be found in #{@channel}"
      false
    else
      user[1]
    end
  end

  def parse_message(m, query)
    message = Regexp.new('^#\S+\s\S+\s(.+)', true).match(query)
    if message.nil?
      message[1] = ' '
    end

    message[1]
  end

  def parse_mask(query)
    mask = Regexp.new('^#\S+\s(\S+)', true).match(query)
    mask[1]
  end

  def ban(m, query)
    @channel = parse_channel(m, query)
    if @channel && Channel(@channel).opped?(m.user.nick)
      @user = parse_user(m, query)
      if @user
        @message = parse_message(m, query)
        Channel(@channel).ban("*!*@#{User(@user).host}")
        Channel(@channel).kick(@user, @message)
      end
    end
  end

  def unban(m, query)
    @channel = parse_channel(m, query)
    if @channel && Channel(@channel).opped?(m.user.nick)
      @mask = parse_mask(query)
      if @mask
        Channel(@channel).unban(@mask)
      end
    end
  end
end