class CreateJidoGuardianRels < ActiveRecord::Migration
  def self.up
    create_table :jido_guardian_rels do |t|
      t.integer :boy_id
      t.integer :guardian_id
      t.string  :relation
      t.string  :zokugara
      t.date    :date_expired 
      t.timestamps
    end
  end

  def self.down
    drop_table :jido_guardian_rels
  end
end