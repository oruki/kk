=begin rdoc
date::2009.06.10
auth:yasui
====児童指導員関係モデル
=end
class Rel < ActiveRecord::Base
#validations	
  validates_presence_of :boy
  validates_presence_of :staff

#relations
# 多対多関連モデル
  belongs_to :boy
  belongs_to :staff

#scopes
  named_scope :of_staff,lambda { |x| { :conditions => ["staff_id = ?", x ] }}
  named_scope :of_boy,  lambda { |x| { :conditions => ["boy_id   = ?", x ] }}   
end