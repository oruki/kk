class CreateGuardians < ActiveRecord::Migration
  def self.up
    create_table :guardians do |t|
      t.string  :name
      t.string  :kana_name
      t.date    :birth_date
      t.integer :sex
      t.string  :occupation
      t.string  :cond_income
      t.string  :cond_health
      t.string  :tel
      t.string  :tel_hp
      t.string  :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :guardians
  end
end