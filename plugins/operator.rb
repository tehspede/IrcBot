class Operator
  include Cinch::Plugin

  set :help, <<-HELP
    "!ban <user> <channel> <reason>" Ban a user from a channel
  HELP

  match(/ban (.+)/, method: :ban)
  match(/kb (.+)/, method: :ban)

  def ban(m, query)
    user = (/^([\w|\d]+)\s/).match(query)
    channel = ()
  end
end