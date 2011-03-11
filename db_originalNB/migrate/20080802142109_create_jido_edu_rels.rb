class CreateJidoEduRels < ActiveRecord::Migration
  def self.up
    create_table :jido_edu_rels do |t|
      t.integer :boy_id
      t.integer :edu_inst_id
      t.integer :val_flag
      t.date    :date_expired
      t.date    :date_entered
      t.timestamps
    end
  end

  def self.down
    drop_table :jido_edu_rels
  end
end