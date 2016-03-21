require_relative '../plugins/tvdb'
require_relative 'spec_helper'
require_relative '../config'

describe 'Instance of', Tvdb do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Tvdb)
    @tvdb = Tvdb.new(@bot)
    @tvdb.query = 'Suits'
  end

  it 'should have a valid id' do
    id = @tvdb.id
    expect(id).to eq('247808')
  end

  it 'should have a valid url' do
    url = @tvdb.get_url
    expect(url).to eq("http://thetvdb.com/api/#{TVDB_APIKEY}/series/247808/all/en.xml")
  end

  it 'should have a valid show name' do
    name = @tvdb.name
    expect(name).to eq('Suits')
  end

  it 'should have a valid network' do
    network = @tvdb.network
    expect(network).to eq('USA Network')
  end

  it 'should have a valid status' do
    status = @tvdb.status
    expect(status).to eq('Continuing')
  end

  it 'should return a valid result' do
    replies = get_replies(make_message(@bot, '!tv Suits'))
    expect(replies.last.text).to eq('Show: Suits :: Network: USA Network :: Status: Continuing')
  end
end