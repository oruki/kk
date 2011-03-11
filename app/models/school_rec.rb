=begin rdoc
date::2009.06.10
auth:yasui
====学校記録モデル
=end

class SchoolRec < ActiveRecord::Base
#constants
  SCHOOL_STATUS = [
    ["欠席",    "absent"],
    ["遅刻",    "late"],
    ["早退",    "hayabiki"],
    ["休校",    "off"]
  ]
#validations
  validates_presence_of :boy_id, :message => '←児童が入力されていません'
  validates_presence_of :staff_id, :message => '←指導員が入力されていません'
  validates_presence_of :date, :message => '←年月日が入力されていません'
  validates_presence_of :status, :message => '←区分が入力されていません'

#relations
# 多対一関連　相手：has_many
  belongs_to :boy
  belongs_to :staff

#scopes
  named_scope :of_today, :conditions => ["date(date)  = ?", Time.zone.now.to_date ]
# 因数xに年号を入れる（ﾃｷｽﾄ）
  named_scope :selected_year,  lambda { |x| { :conditions => ["strftime('%Y',date) = ?", x ] }}
# 因数xに月数を入れる（ﾃｷｽﾄ）
  named_scope :selected_month, lambda { |x| { :conditions => ["strftime('%m',date) = ?", x ] }}
# x=@boyids 
  named_scope :selected_boys,  lambda { |x| { :conditions => ["boy_id IN (?)", x ] }} 
  named_scope :between_dates,  lambda {|from, to| {
    :conditions => ['date between ? and ?', from, to], :order => 'date DESC'} }
end