class CreateTankiShienMokuhyos < ActiveRecord::Migration
  def self.up
    create_table :tanki_shien_mokuhyos do |t|
      t.integer    :shien_keikaku_id, :code
      t.string     :kadai, :mokuhyo, :naiyo, :hyoka, :misc
      t.date       :date
      t.timestamps
    end
  end

  def self.down
    drop_table :tanki_shien_mokuhyos
  end
end