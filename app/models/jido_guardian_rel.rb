=begin rdoc
date::2009.06.10
auth:yasui
====児童保護者モデル
=end

class JidoGuardianRel < ActiveRecord::Base
#validations
  validates_presence_of :boy
  validates_presence_of :guardian
  validates_presence_of :relation

#relations
# 多対多関連モデル
  belongs_to :boy
  belongs_to :guardian
end 