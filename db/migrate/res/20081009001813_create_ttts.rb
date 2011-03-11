class CreateTtts < ActiveRecord::Migration
  def self.up
    create_table :ttts do |t|
      t.date :hiduke
      t.string :jikan
      t.string :fun

      t.timestamps
    end
  end

  def self.down
    drop_table :ttts
  end
end
