=begin rdoc
date::2009.06.10
auth:yasui
====グループモデル
=end

class Group < ActiveRecord::Base
#validations
  validates_presence_of :name
  validates_presence_of :cat
  validates_presence_of :misc
  
#relations
#　多対多関連 :dependent => :destroy　により同時削除可能となる
  has_many :jido_grp_rels, :dependent => :destroy
  has_many :boys, :through => :jido_grp_rels
# 一対多関連　相手：belongs_to   
  has_many :group_recs
     
  default_scope :order => 'cat DESC, name ASC'
end