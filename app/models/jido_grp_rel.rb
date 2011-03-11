=begin rdoc
date::2009.06.10
auth:yasui
====児童グループ関係モデル
=end

class JidoGrpRel < ActiveRecord::Base
#validations
  validates_presence_of :boy
  validates_presence_of :group

#relations  
# 多対多関連モデル
  belongs_to :boy
  belongs_to :group
end