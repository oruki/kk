=begin rdoc
date::2009.06.10
auth:yasui
====短期支援計画（目標）モデル
=end

class TankiShienMokuhyo < ActiveRecord::Base
# validations
  validates_presence_of :shien_keikaku, :cat
  validates_presence_of :kadai, :mokuhyo, :date
# relations
  belongs_to :shien_keikaku
# scopes
  named_scope:cat_01, 
    :conditions => {:cat => "cat-01"}
  named_scope :cat_02,
    :conditions => {:cat => "cat-02"}
  named_scope:cat_03,
    :conditions => {:cat => "cat-03"}
  named_scope:cat_04,
    :conditions => {:cat => "cat-04"} 
  named_scope:category,
    lambda {
      |x| {
      :conditions => ["cat= ?", x ] 
      }
    }     
  named_scope:cat,
    lambda {
      |x| {
        :conditions => ["cat= ?", x ] 
      }
    }
  named_scope:shien_keikaku_id,
    lambda {
      |x| {
        :conditions => ["shien_keikaku_id = ?", x ] 
      }
    }   
end