pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞グループ記録", :size => 8
    period = "#{session[:yy]}-#{session[:mm]}"
    pdf.text "グループ記録（#{period}）", :size => 8, :align => :center
    
# @day_recs
 # my_data = @group_recs.map{|i| [ i.hizuke.to_s+" "+i.staff.name, i.desc, i.misc, i.query ] }
my_data = @group_recs.map{|i| [i.group_id.to_s+" "+i.hizuke.to_s, i.desc.cr(31), i.misc.cr(8), i.query.cr(8) ] } 

# pdf.text_options.update(:wrap => :character)
pdf.table my_data,
    :font_size  => 8,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
  :column_widths      => { 0 => 45, 1 => 280, 2 => 80, 3 => 80 }