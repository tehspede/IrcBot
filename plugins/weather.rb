class Weather
  include Cinch::Plugin

  match(/weather (.+)/, method: :weather)
end