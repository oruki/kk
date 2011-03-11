=begin rdoc
date::2009.06.10
auth:yasui
====預かり金モデル
* 児童ＩＤと保護者ＩＤが必ず必要
* Model for manage accounting deposit or money of boys
=end

class Account < ActiveRecord::Base
# validations
    validates_presence_of :boy_id
    validates_presence_of :amount, :hizuke
# relations
    belongs_to :boy
    belongs_to :guardian
#scopes 
    
   named_scope :between_dates,  lambda {|from, to| {
     :conditions => ['hizuke between ? and ?', from, to], :order => 'hizuke DESC'} }    
end