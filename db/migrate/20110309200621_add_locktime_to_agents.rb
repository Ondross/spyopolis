class AddLocktimeToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :locktime, :decimal
  end

  def self.down
    remove_column :agents, :locktime
  end
end
