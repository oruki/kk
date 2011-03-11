class CreateMessageStaffRels < ActiveRecord::Migration
  def self.up
    create_table :message_staff_rels do |t|
      t.integer :message_id
      t.integer :staff_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_staff_rels
  end
end
