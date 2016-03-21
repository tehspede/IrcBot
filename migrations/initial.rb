require_relative '../config/environment'

class InitialMigration < ActiveRecord::Migration
  def up
    create_table :weather_commands do |t|
      t.string  :user
      t.string  :location
      t.time    :timestamp
    end
  end

  def down
    drop_table :weather_commands
  end
end