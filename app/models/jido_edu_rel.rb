=begin rdoc
date::2009.06.10
auth:yasui
====児童教育機関モデル
=end

class JidoEduRel < ActiveRecord::Base
#validations
  validates_presence_of :boy
  validates_presence_of :edu_inst

#relations
# 多対多関連モデル
  belongs_to :boy
  belongs_to :edu_inst
end