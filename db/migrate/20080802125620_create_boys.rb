class CreateBoys < ActiveRecord::Migration
  def self.up
    create_table :boys do |t|
      t.string  :name
      t.string  :kana_name
      t.date    :birthdate
      t.integer :sex
      t.string  :status #これを追加する　00：退所児童（２桁目オプション）　01：在所児童
      t.timestamps
    end
  end

  def self.down
    drop_table :boys
  end
end