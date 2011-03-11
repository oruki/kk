class CreateDaichos < ActiveRecord::Migration
  def self.up
    create_table :daichos do |t|
      t.integer :boy_id
      t.text    :desc1, :desc2, :desc3, :desc4
      t.date    :day_ent, :day_ext
      t.string  :add_perm, :add_prev, :place_born
      t.string  :sochi, :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :daichos
  end
end