class CreateAttends < ActiveRecord::Migration
  def self.up
    create_table :attends do |t|
      t.integer  :staff_id
      t.datetime :time_start, :time_end
      t.string   :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :attends
  end
end