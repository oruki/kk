=begin rdoc
date::2009.06.10
auth:yasui
====指導記録モデル
=end

class ShidouRec < ActiveRecord::Base
#validations
  validates_presence_of :date, :boy_id, :staff_id, :cat, :desc

#relations
# 多対一関連　相手：has_many
  belongs_to :boy
  belongs_to :staff

#scopes

# expr [NOT] IN ( value-list ) ﾃﾞｰﾀ抽出
   named_scope :of_today,       :conditions => ["date(date)  = ?", Time.zone.now.to_date ] 
#日付ﾌｨｰﾙﾄﾞがxであるようなﾚｺｰﾄﾞを抽出
   named_scope :of_attend_date, lambda { |x| { :conditions => ["date(date) = ?", x ] }}
   named_scope :selected_year,  lambda { |x| { :conditions => ["strftime('%Y',date) = ?", x ] }}   
   named_scope :selected_month, lambda { |x| { :conditions => ["strftime('%m',date) = ?", x ] }}   
# x=@boyids　boy_idに該当するﾃﾞｰﾀ抽出
   named_scope :selected_boys,  lambda { |x| { :conditions => ["boy_id IN (?)", x ] }}
   named_scope :of_boy,         lambda { |x| { :conditions => ["boy_id = ?", x ] }}
   named_scope :of_date,        lambda { |x| { :conditions => ["date(date) = ?", x ] }}
   named_scope :between_dates,  lambda {|from, to| {:include => [:boy],
     :conditions => ['date between ? and ?', from, to], :order => 'date DESC'} }
# category　が hiyari_hat であるレコードを抽出
   named_scope :of_cat,
     lambda { |x| { :conditions => ["cat = ?", x ] }}
   named_scope :of_like_cat,
     lambda { |x| { :conditions => ["cat like ?", "%"+x+"%"]}} 
     
end