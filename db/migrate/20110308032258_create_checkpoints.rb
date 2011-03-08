class CreateCheckpoints < ActiveRecord::Migration
  def self.up
    create_table :checkpoints do |t|
      t.float :lat
      t.float :long
      t.integer :data_count

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoints
  end
end
