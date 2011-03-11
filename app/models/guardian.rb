=begin rdoc
date::2009.06.10
auth:yasui
====保護者モデル
=end

class Guardian < ActiveRecord::Base
#　validation
  validates_presence_of :name, :message => '名前を入力してください'
  validates_presence_of :kana_name, :message => 'フリガナを入力してください'
  validates_presence_of :birth_date, :message => '生年月日を入力してください'
  validates_presence_of :sex, :message => '性別を入力してください'

# relations
#　多対多関連 :dependent => :destroy　により同時削除可能となる
  has_many :jido_guardian_rels, :dependent => :destroy
  has_many :boys, :through => :jido_guardian_rels
# 多対一関連　相手：belongs_to
  has_many :stay_out_recs
end