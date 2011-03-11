class CreateGroupRecs < ActiveRecord::Migration
  def self.up
    create_table :group_recs do |t|
      t.integer :group_id, :staff_id
      t.string  :desc, :misc, :query, :cat
      t.date    :hizuke
      t.timestamps
    end
  end

  def self.down
    drop_table :group_recs
  end
end