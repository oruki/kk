class MessageStaffRel < ActiveRecord::Base

validates_presence_of :staff_id, :message => '&#8592;&#35352;&#20837;&#12375;&#12383;&#12473;&#12479;&#12483;&#12501;&#12398;&#21517;&#21069;&#12364;&#20837;&#21147;&#12373;&#12428;&#12390;&#12356;&#12414;&#12379;&#12435;'

belongs_to :message_staff_rels_message
belongs_to :message_staff_rels_staff
end