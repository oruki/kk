=begin ■ requirements and vals
=end
require "prawn/measurement_extensions"
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
# 変数2
kari = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
inst_name = kari['inst_name']

=begin ■ logotype
=end
prawn_logo = "#{RAILS_ROOT}/public/images/sample.jpg"
pdf.image prawn_logo, :at => [155.mm,280.mm], :width => 45
 
=begin ■ footer
=end
pdf.instance_eval do
  footer [margin_box.left, margin_box.bottom + 20] do
    stroke_color "888888"
    stroke_horizontal_rule
    move_down(1.mm)
    text "#{inst_name} #{' '*46}  page:#{pdf.page_count}",
      :size => 8,
      :align => :right
  end
end

# table data
  xx = @shidou_recs 
  my_data = xx.map{|i| [i.date, i.created_at.strftime("%H：%M") , i.cat, i.desc.cr(30), i.staff.name ] }
  period = "#{session[:yy]}-#{session[:mm]}"
  thename = @case_rec.boy.name
  
pdf.instance_eval do
	
  bounding_box bounds.top_left,
      :width => bounds.width,
      :height => bounds.height - 20 do
      		
=begin ■ titles  
=end	
  pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」>指導記録", :size => 8
  pdf.move_down(10)

    
  pdf.text "指導記録（#{thename}|#{period}）", :size => 11, :align => :center   
    pdf.move_down(6)
    pdf.stroke_horizontal_rule
    pdf.move_down(20)
    
=begin ■ inkan  
=end
  pdf.cell [0.mm, 245.mm],
        :width => 40.mm, :height => 15.mm,
        :text  => "児童氏名：#{thename}"+"\n"+"集計期間:#{period}",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 8
  pdf.cell [40.mm, 245.mm],
        :width => 62.5.mm, :height => 15.mm,
        :text  =>  "備考・追記",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 5
  pdf.cell [102.5.mm, 245.mm],
        :width => 15.mm, :height => 15.mm,
        :text  =>  "施設長",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 5    
  pdf.cell [117.5.mm, 245.mm],
        :width => 15.mm, :height => 15.mm,
        :text  =>  "担当者",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 5   
  pdf.cell [132.5.mm, 245.mm],
        :width => 15.mm, :height => 15.mm,
        :text  =>  "担当者",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 5 
  pdf.cell [147.5.mm, 245.mm],
        :width => 15.mm, :height => 15.mm,
        :text  =>  "担当者",
        :align => :left,
        :padding => 3,
        :text_color => '000000',
        :font_size => 5 
  pdf.move_down(4)
  
=begin ■ main table
# @shidou_recs = ShidouRec.find(session[:ext])
# my_data = xx.map{|i| [i.date, i.boy.id, i.boy.name, i.staff.name, i.cat, i.desc] }
# pdf.text_options.update(:wrap => :character)
=end
  pdf.text_options.update(:wrap => :space)
  pdf.table my_data,
    :font_size  => 8,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :left,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["日 付", "時　間", "分 類", "内 容", "指導員名"],
    :column_widths      => {0=>20.mm, 1=>15.mm, 2=>20.mm, 3=>90.mm, 4=>17.5.mm}

  end 
end	



