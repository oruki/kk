class CreateSchoolRecs < ActiveRecord::Migration
  def self.up
    create_table :school_recs do |t|
      t.date    :date
      t.integer :boy_id
      t.integer :staff_id
      t.string  :status
      t.text    :message_to
      t.text    :message_from
      t.string  :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :school_recs
  end
end