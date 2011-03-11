class CreateCaseRecs < ActiveRecord::Migration
  def self.up
    create_table :case_recs do |t|
      t.integer :boy_id, :flag
      t.string  :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :case_recs
  end
end