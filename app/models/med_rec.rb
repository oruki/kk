=begin rdoc
date::2009.06.10
auth:yasui
====医療記録モデル
=end

class MedRec < ActiveRecord::Base
#validations
  validates_presence_of :date,       :message => '日付が入力されていません'
  validates_presence_of :boy,        :message => '児童の名前が入力されていません'
  validates_presence_of :staff,      :message => '指導員の名前が入力されていません'
  validates_presence_of :med_inst_id,:message => '医療機関の名前が入力されていません'

#relations
# 多対一関連　相手：has_many
  belongs_to :boy
  belongs_to :med_inst
  belongs_to :staff
  
#named scopes  
  named_scope :of_today,       :conditions => ["date(date)  = ?", Time.zone.now.to_date ] 
  named_scope :selected_year,  lambda { |x| { :conditions => ["strftime('%Y',date) = ?", x ] }}
  named_scope :selected_month, lambda { |x| { :conditions => ["strftime('%m',date) = ?", x ] }}
  named_scope :selected_boys,  lambda { |x| { :conditions => ["boy_id IN (?)", x ] }}             # x=@boyids  
  named_scope :between_dates,  lambda {|from, to| {
    :conditions => ['date between ? and ?', from, to], :order => 'date DESC'} }
end