require_relative '../plugins/topic'
require_relative 'spec_helper'

describe Topic do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Topic)
    @topic = Topic.new(@bot)
  end

  context '#parse_channel' do
    it 'should recognise a valid channel from the command' do
      channel = @topic.parse_channel('#test This is a topic')
      expect(channel).to eq('#test')
    end

    it 'should return false on no valid channel' do
      channel = @topic.parse_channel('test This is a topic')
      expect(channel).to eq(false)
    end
  end

  context '#parse_topic' do
    it 'should recognise the wanted topic' do
      topic = @topic.parse_topic('#test This is a topic')
      expect(topic).to eq('This is a topic')
    end

    it 'should return false on an empty topic' do
      topic = @topic.parse_topic('#test ')
      expect(topic).to eq(false)
    end
  end
end