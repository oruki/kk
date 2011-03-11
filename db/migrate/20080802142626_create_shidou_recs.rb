class CreateShidouRecs < ActiveRecord::Migration
  def self.up
    create_table :shidou_recs do |t|
      t.date    :date
      t.integer :boy_id
      t.integer :staff_id
      t.string  :cat
      t.string  :desc
      t.string  :taisaku      
      t.string  :basho      
      t.timestamps
    end
  end

  def self.down
    drop_table :shidou_recs
  end
end