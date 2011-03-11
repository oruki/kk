# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090623092625) do

  create_table "accounts", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "guardian_id"
    t.integer  "amount"
    t.string   "rcv_name"
    t.string   "acnt"
    t.string   "desc"
    t.string   "misc"
    t.date     "hizuke"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "title"
    t.string   "cat"
    t.string   "pos"
    t.string   "cont"
    t.string   "reporter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attends", :force => true do |t|
    t.integer  "staff_id"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boys", :force => true do |t|
    t.string   "name"
    t.string   "kana_name"
    t.date     "birthdate"
    t.integer  "sex"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "case_recs", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "flag"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cats", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daichos", :force => true do |t|
    t.integer  "boy_id"
    t.text     "desc1"
    t.text     "desc2"
    t.text     "desc3"
    t.text     "desc4"
    t.date     "day_ent"
    t.date     "day_ext"
    t.string   "add_perm"
    t.string   "add_prev"
    t.string   "place_born"
    t.string   "sochi"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_recs", :force => true do |t|
    t.integer  "staff_id"
    t.string   "tenki"
    t.string   "dekigoto"
    t.string   "misc"
    t.date     "hizuke"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edu_insts", :force => true do |t|
    t.string   "name"
    t.string   "kana_name"
    t.string   "cat"
    t.string   "zip"
    t.string   "add"
    t.string   "tel"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_recs", :force => true do |t|
    t.integer  "group_id"
    t.integer  "staff_id"
    t.string   "desc"
    t.string   "misc"
    t.string   "query"
    t.string   "cat"
    t.date     "hizuke"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "cat"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guardians", :force => true do |t|
    t.string   "name"
    t.string   "kana_name"
    t.date     "birth_date"
    t.integer  "sex"
    t.string   "occupation"
    t.string   "cond_income"
    t.string   "cond_health"
    t.string   "tel"
    t.string   "tel_hp"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jido_edu_rels", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "edu_inst_id"
    t.integer  "val_flag"
    t.date     "date_expired"
    t.date     "date_entered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jido_grp_rels", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "group_id"
    t.date     "date_expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jido_guardian_rels", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "guardian_id"
    t.string   "relation"
    t.string   "zokugara"
    t.date     "date_expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "med_insts", :force => true do |t|
    t.string   "name"
    t.string   "kana_name"
    t.string   "cat"
    t.string   "zip"
    t.string   "add"
    t.string   "tel"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "med_recs", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "staff_id"
    t.integer  "med_inst_id"
    t.date     "date"
    t.string   "symptom"
    t.string   "status"
    t.string   "temperature"
    t.string   "insulance"
    t.text     "condition"
    t.text     "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_staff_rels", :force => true do |t|
    t.integer  "message_id"
    t.integer  "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.date     "date"
    t.integer  "staff_id"
    t.string   "msg_to"
    t.string   "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rels", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "staff_id"
    t.string   "relation"
    t.date     "date_expired"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_recs", :force => true do |t|
    t.date     "date"
    t.integer  "boy_id"
    t.integer  "staff_id"
    t.string   "status"
    t.text     "message_to"
    t.text     "message_from"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shidou_recs", :force => true do |t|
    t.date     "date"
    t.integer  "boy_id"
    t.integer  "staff_id"
    t.string   "cat"
    t.string   "desc"
    t.string   "taisaku"
    t.string   "basho"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shien_keikakus", :force => true do |t|
    t.date     "date"
    t.date     "jikai_sakutei_date"
    t.integer  "boy_id"
    t.integer  "staff_id"
    t.integer  "sakutei_bango"
    t.string   "shutaru_mondai"
    t.string   "honnin_ikou"
    t.string   "hogosha_ikou"
    t.string   "school_iken"
    t.string   "jidou_sodan_kyogi"
    t.string   "shien_hoshin"
    t.string   "choki_kodomo"
    t.string   "choki_katei"
    t.string   "choki_chiiki"
    t.string   "choki_sogo"
    t.string   "tokki_sogo"
    t.string   "misc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staff_recs", :force => true do |t|
    t.string   "hours"
    t.string   "minutes"
    t.integer  "attend_id"
    t.string   "in_out"
    t.string   "yoken"
    t.string   "naiyo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", :force => true do |t|
    t.string   "name"
    t.string   "kana_name"
    t.date     "birth_date"
    t.integer  "sex"
    t.string   "resd_add"
    t.string   "per_add"
    t.string   "tel"
    t.string   "tel_hp"
    t.string   "shokumei"
    t.date     "saiyobi"
    t.integer  "user_id"
    t.binary   "imgd"
    t.string   "imgf"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stay_out_recs", :force => true do |t|
    t.integer  "boy_id"
    t.integer  "guardian_id"
    t.integer  "staff_id"
    t.string   "place"
    t.string   "case_category"
    t.string   "app_address"
    t.string   "app_name"
    t.string   "rcv_name"
    t.string   "confirmation"
    t.date     "date"
    t.date     "app_date"
    t.date     "rcv_date"
    t.date     "period_from"
    t.date     "period_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tanki_shien_mokuhyos", :force => true do |t|
    t.integer  "shien_keikaku_id"
    t.string   "cat"
    t.string   "code"
    t.string   "kadai"
    t.string   "mokuhyo"
    t.string   "naiyou"
    t.string   "hyoka"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
