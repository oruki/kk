=begin rdoc
date::2009.06.10
auth:yasui
====業務記録モデル
=end

class DayRec < ActiveRecord::Base
#validations
  validates_presence_of :hizuke,   :message => '←日付を入力してください'
  validates_presence_of :tenki,    :message => '←天気を入力してください'
  validates_presence_of :dekigoto, :message => '←出来事を入力してください'
  validates_presence_of :staff_id, :message => '←ｽﾀｯﾌを入力してください'
  
#relations
# 多対一関連　相手：has_many
  belongs_to :staff

# scopes
  default_scope :order => 'hizuke DESC'
  named_scope :of_today,       :conditions => ["date(hizuke)  = ?", Time.zone.now.to_date ] 
  named_scope :selected_year,  lambda { |x| { :conditions => ["strftime('%Y',hizuke) = ?", x ] }}
  named_scope :selected_month, lambda { |x| { :conditions => ["strftime('%m',hizuke) = ?", x ] }}
  named_scope :selected_boys,  lambda { |x| { :conditions => ["boy_id IN (?)", x ] }}
  named_scope :between_dates,  lambda {|from, to| {:conditions => ['hizuke between ? and ?', from, to]} }
end