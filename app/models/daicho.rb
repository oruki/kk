=begin rdoc
author::	ikuro.yasui
date::		2009-06-10
=====Daicho について
* 児童毎のケース児童台帳
* 児童について通常は１の児童台帳を作成する
* 児童のリンク情報
  * 学校記録
  * 保護者情報
  * その他
* 台帳に固定の情報（台帳が持つ個別フィールド）
  * 日付　入所日　退所日
  * 住所　出生地　本籍　前住所
  * 記述　環境　判定　問題  備考
=end

class Daicho < ActiveRecord::Base
#validations
  validates_presence_of :boy_id, :day_ent, :add_perm, :place_born
#relations
# 多対一関連　相手：has_many 
  belongs_to :boy
end