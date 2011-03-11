class CreateMedRecs < ActiveRecord::Migration
  def self.up
    create_table :med_recs do |t|
      t.integer :boy_id, :staff_id, :med_inst_id 
      t.date    :date
      t.string  :symptom, :status, :temperature, :insulance
      t.text    :condition, :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :med_recs
  end
end