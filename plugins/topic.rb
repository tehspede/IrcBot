require 'cinch/plugin'

class Topic
  include Cinch::Plugin

  match(/topic (.+)/, method: :topic)

  def parse_channel(m, query)
    channel = Regexp.new('^(#\S+)\s', true).match(query)
    if channel.nil?
      m.reply 'No channel could be parsed! Please use the format "!topic <channel> <topic>"'
      false
    elsif !@bot.channels.include?(channel[1])
      m.reply "I am not in the channel #{channel}"
      false
    else
      channel[1]
    end
  end

  def parse_topic(m, query)
    topic = (/\s(.+)/).match(query)
    if topic.nil?
      m.reply 'No topic could be parsed! Please use the format "!topic <channel> <topic>"'
      false
    else
      topic[1]
    end
  end

  def topic(m, query)
    channel = parse_channel(m, query)
    topic = parse_topic(m, query)

    if channel && topic && @bot.channels.include?(channel)
      if Channel(channel).opped?(m.user.nick)
        Channel(channel).topic = topic
      end
    end
  end
end