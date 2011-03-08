class AddPasswordToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :password, :string
  end

  def self.down
    remove_column :agents, :password
  end
end
