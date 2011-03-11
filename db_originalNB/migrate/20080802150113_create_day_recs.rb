class CreateDayRecs < ActiveRecord::Migration
  def self.up
    create_table :day_recs do |t|
      t.integer  :staff_id    
      t.string  :tenki, :dekigoto, :misc
      t.date    :hizuke
      t.timestamps
    end
  end

  def self.down
    drop_table :day_recs
  end
end