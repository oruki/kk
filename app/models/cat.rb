class Cat < ActiveRecord::Base
	
	default_scope :order => 'title DESC, subtitle DESC, value ASC'
end
