=begin rdoc
date::2009.06.10
auth:yasui
====医療機関モデル
=end

class MedInst < ActiveRecord::Base
#validations
  validates_presence_of :name, :message => '←名前を入力してください'
  validates_presence_of :kana_name, :message => '←フリガナを入力してください'
  validates_presence_of :cat, :message => '←診察区分を入力してください'
  validates_presence_of :tel, :message => '←電話番号を入力してください'

#relations
# 一対多関連　相手：belongs_to 
  has_many :med_recs
end
