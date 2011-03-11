=begin rdoc
author::	ikuro.yasui
date::		2009-06-10
=====CaseRecモデル
* 児童毎のケース記録台帳
* 児童について通常は１のケース記録を作成する
=end

class CaseRec < ActiveRecord::Base
#validations
  validates_presence_of :boy_id

#relations
# 多対一関連　相手：has_many 
  belongs_to :boy
end  