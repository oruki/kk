class CreateStaffRecs < ActiveRecord::Migration
  def self.up
    create_table :staff_recs do |t|
      t.string :hours
      t.string :minutes
      t.integer :attend_id
      t.string :in_out
      t.string :yoken
      t.string :naiyo

      t.timestamps
    end
  end

  def self.down
    drop_table :staff_recs
  end
end