=begin rdoc
date::2009.06.10
auth:yasui
====伝言板モデル
=end
class Message < ActiveRecord::Base
#validations
  validates_presence_of :staff_id,      :message => '指導員の名前が入力されていません'
  validates_presence_of :msg,           :message => '内容が入力されていません'
  validates_presence_of :date,          :message => '日付が入力されていません'

#relations
# 多対一関連　相手：has_many
  belongs_to :staff
#　多対多関連  
  has_many :message_staff_rels
  has_many :message_staff_rels_staffs, :through => :message_staff_rels

#scopes
  default_scope :order => 'date DESC'

  named_scope :of_today,       :conditions => ["date(date)  = ?", Time.zone.now.to_date ] 
  named_scope :between_dates,
    lambda {|from, to| {:conditions => ['date(date) between ? and ?', from, to]} }
end