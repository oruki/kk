pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」>指導記録", :size => 8
    period = "#{session[:yy]}-#{session[:mm]}"
    pdf.text "指導記録（#{period}）", :size => 14, :align => :center   
    pdf.stroke_horizontal_rule
    pdf.move_down(20)

xx = ShidouRec.find(session[:ext])  

my_data = xx.map{|i| ["#{i.boy.id}&nbsp;&nbsp;#{i.boy.name}", "#{i.date}&nbsp;&nbsp;#{i.staff.name}", i.cat, i.desc ] }
pdf.text_options.update(:wrap => :character)
 pdf.table my_data,
    :font_size  => 6,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["児童ID/氏名", "日付/指導員名","分類","内容"],
    :widths             => {0=>60, 1=>60, 2=>40, 3=>340 }
pdf.move_down(20)
pdf.stroke_horizontal_rule
pdf.text "innovative data design by EMU", :size => 10