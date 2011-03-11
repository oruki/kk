=begin rdoc
date::2009.06.10
auth:yasui
====外出外泊モデル
=end

class StayOutRec < ActiveRecord::Base
# validations
  validates_presence_of :boy, :staff, :guardian
  validates_presence_of :date
# relations
  belongs_to :staff
  belongs_to :boy
  belongs_to :guardian
# scopes
  named_scope :of_today,       :conditions => ["date(date)  = ?", Time.zone.now.to_date ] 
  named_scope :selected_year,  lambda { |x| { :conditions => ["strftime('%Y',date) = ?", x ] }}
  named_scope :selected_month, lambda { |x| { :conditions => ["strftime('%m',date) = ?", x ] }}
# x=@boyids 
  named_scope :selected_boys,  lambda { |x| { :conditions => ["boy_id IN (?)", x ] }}
  named_scope :between_dates,  lambda {|from, to| {
    :conditions => ['date between ? and ?', from, to], :order => 'date DESC'} }
end
 