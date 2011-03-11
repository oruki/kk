class CreateShienKeikakus < ActiveRecord::Migration
  def self.up
    create_table :shien_keikakus do |t|
      t.date    :date, :jikai_sakutei_date
      t.integer :boy_id, :staff_id, :sakutei_bango
      t.string  :shutaru_mondai, :honnin_ikou, :hogosha_ikou, :school_iken
      t.string  :jidou_sodan_kyogi, :shien_hoshin
      t.string  :choki_kodomo, :choki_katei, :choki_chiiki, :choki_sogo, :tokki_sogo, :misc 
      t.timestamps
    end
  end

  def self.down
    drop_table :shien_keikakus
  end
end