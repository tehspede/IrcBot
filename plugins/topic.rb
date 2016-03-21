require 'cinch/plugin'

class Topic
  include Cinch::Plugin

  match(/topic (.+)/, method: :topic)

  def parse_channel(query)
    channel = Regexp.new('^(#\S+)\s', true).match(query)
    channel.nil? ? false : channel[1]
  end

  def parse_topic(query)
    topic = (/\s(.+)/).match(query)
    topic.nil? ? false : topic[1]
  end

  def topic(m, query)
    channel = parse_channel(query)
    topic = parse_topic(query)

    if channel && topic
      topic = parse_topic(query)
      if Channel(channel).opped?(m.user.nick)
        Channel(channel).topic = topic
      end
    else
      m.reply 'No channel was recognised from your command.'
    end
  end
end