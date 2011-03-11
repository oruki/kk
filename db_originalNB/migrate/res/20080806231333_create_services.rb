class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer  :staff_id
      t.datetime :service_on, :service_off
      t.string   :misc
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end