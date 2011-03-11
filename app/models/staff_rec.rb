=begin rdoc
date::2009.06.10
auth:yasui
====指導員記録モデル
=end

class StaffRec < ActiveRecord::Base
# validations
  validates_presence_of :attend_id, :hours, :minutes, :in_out
# relations
  belongs_to :attend
  belongs_to :staff
# scopes
#  expr [NOT] IN ( value-list ) ﾃﾞｰﾀ抽出
#figure of hours is h
  named_scope :hours_is,   lambda { |h| { :conditions => ["strftime('%H',time) = ?", h ] }}   
# figure of minutes is m
  named_scope :minutes_is,
    lambda {
      |m| {
        :conditions => ["strftime('%M',time) = ?", m ]
      }
    }   
  named_scope :minutes_is,
    lambda {
      |h,m| {
        :conditions => ["strftime('%H',time) = ? and strftime('%M',time) = ?", h, m ]
      }
    }
  named_scope :age_between,
    lambda {
      |from, to| {
        :conditions => ['age between ? and ?', from, to]
      }
    }

end