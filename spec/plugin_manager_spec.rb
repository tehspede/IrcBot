require_relative '../plugins/plugin_manager'
require_relative 'spec_helper'

describe 'Instance of', PluginManager do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(PluginManager)
  end

  it 'should load a valid plugin if authorized' do
    replies = get_replies(make_message(@bot, '!plugin load tvdb', {nick: 'tehspede'}))
    expect(replies.last.text).to eq('Successfully loaded tvdb')
    replies = get_replies(make_message(@bot, '!tv suits'))
    expect(replies.last.text).to eq('Show: Suits :: Network: USA Network :: Status: Continuing')
  end

  it 'should not load a plugin if not authorized' do
    replies = get_replies(make_message(@bot, '!plugin load tvdb'))
    expect(replies.last.text).to eq('You don\'t have permission to use this command!')
  end

  it 'should not load an invalid plugin id authorized' do
    replies = get_replies(make_message(@bot, '!plugin load asdf', {nick: 'tehspede'}))
    expect(replies.last.text).to eq('File asdf.rb does not exist!')
  end

  it 'should disable a valid plugin if authorized' do
    replies = get_replies(make_message(@bot, '!plugin disable tvdb', {nick: 'tehspede'}))
    expect(replies.last.text).to eq('Successfully disabled tvdb')
    replies = get_replies(make_message(@bot, '!tv suits'))
    expect(replies.last).to eq(nil)
  end

  it 'should not disable a plugin if not authorized' do
    replies = get_replies(make_message(@bot, '!plugin disable tvdb'))
    expect(replies.last.text).to eq('You don\'t have permission to use this command!')
  end

  it 'should reload a valid plugin if authorized' do
    get_replies(make_message(@bot, '!plugin load tvdb', {nick: 'tehspede'}))
    replies = get_replies(make_message(@bot, '!plugin reload tvdb', {nick: 'tehspede'}))
    expect(replies.last.text).to eq('Successfully reloaded tvdb')
  end

  it 'should not reload a plugin if not authorized' do
    replies = get_replies(make_message(@bot, '!plugin reload tvdb'))
    expect(replies.last.text).to eq('You don\'t have permission to use this command!')
  end
end