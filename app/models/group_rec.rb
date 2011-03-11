=begin rdoc
date::2009.06.10
auth:yasui
====グループ記録モデル
=end

class GroupRec < ActiveRecord::Base
# validations
  validates_presence_of :hizuke,   :message => '←日付が入力されていません'

  validates_presence_of :group_id, :message => '←グループが入力されていません'
  validates_presence_of :staff_id, :message => '←ｽﾀｯﾌの名前が入力されていません'
# relations
  belongs_to :group
  belongs_to :staff
# scopes
  named_scope:of_group_cat,
    lambda {
      |x| { :conditions => ["group_id IN (?)", Group.all.select{|i| i.cat == x}.map{|j| j.id} ] }
    }

  named_scope:of_today,
    :conditions => ["date(hizuke)  = ?", Time.zone.now.to_date ] 
  named_scope:selected_year,
    lambda {
      |x| { :conditions => ["strftime('%Y',hizuke) = ?", x ] }
    }
  named_scope:of_group,
    lambda {
      |x| { :conditions => ["group_id = ?", x ] }
    }    
  named_scope:of_date,
    lambda {
      |x| { :conditions => ["date(hizuke) = ?", x ] }
    }
  named_scope:selected_month,
    lambda {
      |x| { :conditions => ["strftime('%m',hizuke) = ?", x ] }
    }
  named_scope:selected_boys,
    lambda {
       |x| { :conditions => ["boy_id IN (?)", x ] }
    }
  named_scope:between_dates,
    lambda {
      |from, to| {:conditions => ['hizuke between ? and ?', from, to], :order => 'hizuke DESC'} 
    }
  named_scope:of_attend_date,
    lambda {
      |x| { :conditions => ["date(hizuke)  = ?", Attend.find(x).time_start.to_date ]} 
    }
  named_scope:of_attend_grp,
    lambda {
      |x| { :conditions => ["group_id IN (?)", Attend.find(x).staff.boys.map{|i| i.groups }.flatten.uniq ]} 
    }

  named_scope:of_attend_dates,
    lambda {
      |x,n| {:conditions => ['hizuke between ? and ?', Attend.find(x).time_start.advance(:days => -n) .to_date, Attend.find(x).time_start.to_date], :order => 'hizuke DESC'} 
    }
    
   named_scope :of_like_cat,
     lambda { |x| { :conditions => ["cat like ?", "%"+x+"%"]}}
     
   named_scope :of_cat,
     lambda { |x| { :conditions => ["cat = ?", x]}} 
          
end






