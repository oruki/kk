class CreateRels < ActiveRecord::Migration
  def self.up
    create_table :rels do |t|
      t.integer :boy_id
      t.integer :staff_id
      t.string  :relation
      t.date    :date_expired
      t.string  :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :rels
  end
end