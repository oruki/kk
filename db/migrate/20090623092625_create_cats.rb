class CreateCats < ActiveRecord::Migration
  def self.up
    create_table :cats do |t|
      t.string :title
      t.string :subtitle
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :cats
  end
end
