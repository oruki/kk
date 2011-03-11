=begin rdoc
date::2009.06.10
auth:yasui
====教育機関モデル
=end

class EduInst < ActiveRecord::Base
#validations
  validates_presence_of :name, :message => '←名前を入力してください'
  validates_presence_of :kana_name, :message => '←フリガナを入力してください'
  validates_presence_of :cat, :message => '←診察区分を入力してください'
  validates_presence_of :tel, :message => '←電話番号を入力してください'

#relations
# 多対多関連 :dependent => :destroy　により同時削除可能となる
  has_many :jido_edu_rels, :dependent => :destroy
  has_many :boys,     :through => :jido_edu_rels    
end
