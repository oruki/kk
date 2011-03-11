class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :boy_id, :guardian_id
      t.integer :amount
  #    t.integer :kari_id, :kasi_id
      t.string  :rcv_name, :acnt, :desc, :misc
      t.date    :hizuke
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end