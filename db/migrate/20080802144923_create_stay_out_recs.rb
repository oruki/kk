class CreateStayOutRecs < ActiveRecord::Migration
  def self.up
    create_table :stay_out_recs do |t|
      t.integer :boy_id, :guardian_id, :staff_id
      t.string :place, :case_category, :app_address, :app_name, :rcv_name, :confirmation
      t.date   :date, :app_date, :rcv_date, :period_from, :period_to
      t.timestamps
    end
  end

  def self.down
    drop_table :stay_out_recs
  end
end