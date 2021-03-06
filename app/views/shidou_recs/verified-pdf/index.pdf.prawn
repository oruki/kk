=begin ■ requirements and vals
=end
# settings
require "prawn/measurement_extensions"
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
# 変数2
kari = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
inst_name = kari['inst_name']




# for demo
  table_data = []
  (1..60).each { |i| table_data << [i] }
  
# table data
# xx = ShidouRec.find(session[:ext]) 
# @shidou_recs = ShidouRec.all
=begin
ShidouRec.find(session[:ext]) は不都合（ソートが反映しない）
  my_data = xx.map{
    |i| [i.date, "#{i.boy.name}\n#{i.boy.id.to_s}", i.staff.name, i.cat, i.desc.cr0(30)[0]]
  }
=end
  my_data = session[:ext].map{|i| ShidouRec.find(i)}.map{
    |i| [i.date, "#{i.boy.name}\n#{i.boy.id.to_s}", i.staff.name, i.cat, i.desc.cr0(30)[0]]
  }
  
  
  
  period = "#{session[:yy]}-#{session[:mm]}"

pdf.instance_eval do
# layout for table inside bb
  bounding_box bounds.top_left,
      :width => bounds.width,
      :height => bounds.height - 20 do
      
#    prawn_logo = "#{RAILS_ROOT}/public/images/sample.jpg"
#    pdf.image prawn_logo, :at => [485,800], :width => 45
    
    pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」>指導記録", :size => 8

    pdf.text "指導記録（#{period}）", :size => 11, :align => :center   
    pdf.move_down(6)
    pdf.stroke_horizontal_rule
    pdf.move_down(20)
    
    pdf.text_options.update(:wrap => :space)
    pdf.table my_data,
      :font_size  => 8,
      :horizontal_padding => 3,
      :vertical_padding   => 5,
      :position           => :center,
      :row_colors         =>["ffffff", "eeeeee"],
      :headers       => ["日 付", "児童氏名/ID", "指導員名", "分 類", "内 容"],
      :column_widths => {0=>20.mm, 1=>20.mm, 2=>20.mm, 3=>20.mm, 4=>90.mm}

#   table table_data
  end 
end