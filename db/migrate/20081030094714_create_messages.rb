class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.date :date
      t.integer :staff_id
      t.string :msg_to
      t.string :msg

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
