class CreateEduInsts < ActiveRecord::Migration
  def self.up
    create_table :edu_insts do |t|
      t.string :name
      t.string :kana_name
      t.string :cat
      t.string :zip
      t.string :add
      t.string :tel
      t.string :fax
      t.timestamps
    end
  end

  def self.down
    drop_table :edu_insts
  end
end