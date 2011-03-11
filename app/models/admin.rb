=begin rdoc
date::2009.06.10
auth:yasui
====管理モデル
=end

class Admin < ActiveRecord::Base
# validations
  validates_presence_of :title, :cat, :cont
end