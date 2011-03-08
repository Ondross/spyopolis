class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.string :name
      t.boolean :carrier
      t.integer :team
      t.float :lat
      t.float :long
      t.integer :data_count
      t.boolean :emp
      t.boolean :locked

      t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
