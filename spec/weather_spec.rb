require_relative '../plugins/weather'
require_relative '../migrations/initial'
require_relative 'spec_helper'

describe 'Instance of', Weather do
  include Cinch::Test

  before(:all) do
    InitialMigration.migrate(:down)
    InitialMigration.migrate(:up)
    @bot = make_bot(Weather)
  end

  it 'should return an error message if user has never used command before' do
    replies = get_replies(make_message(@bot, '!weather'))
    expect(replies.last.text).to eq('You have not used the weather command before with that nick! Please use "!weather <location>"')
  end

  it 'should return a valid result if the location exists' do
    replies = get_replies(make_message(@bot, '!weather Vaasa'))
    expect(replies.last.text).to match(/WEATHER - Vaasa, FI/)
  end

  it 'should remember if the command has been used before' do
    replies = get_replies(make_message(@bot, '!weather'))
    expect(replies.last.text).to match(/WEATHER - Vaasa, FI/)
  end

  it 'should return an error message if no location was found' do
    replies = get_replies(make_message(@bot, '!weather asgsdhdtjtjdjsjaehargafes'))
    expect(replies.last.text).to eq('No city was found with that location!')
  end
end