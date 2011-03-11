class CreateJidoGrpRels < ActiveRecord::Migration
  def self.up
    create_table :jido_grp_rels do |t|
      t.integer :boy_id
      t.integer :group_id
      t.date    :date_expired 
      t.timestamps
    end
  end

  def self.down
    drop_table :jido_grp_rels
  end
end