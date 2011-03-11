class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :title
      t.string :cat
      t.string :pos
      t.string :cont
      t.string :reporter

      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
