class CreateStaffs < ActiveRecord::Migration
  def self.up
    create_table :staffs do |t|
      t.string :name
      t.string :kana_name
      t.date   :birth_date
      t.integer:sex

      t.string :resd_add
      t.string :per_add
      t.string :tel
      t.string :tel_hp

      t.string :shokumei
      t.date   :saiyobi
      t.integer :user_id

      t.binary :imgd
      t.string :imgf
      t.string :photo_url      
      t.timestamps
    end
  end

  def self.down
    drop_table :staffs
  end
end