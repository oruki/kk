require "prawn/measurement_extensions"
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"

pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」>指導記録", :size => 8
    period = "#{session[:yy]}-#{session[:mm]}"
    pdf.text "指導記録（#{period}）", :size => 11, :align => :center   
    pdf.move_down(6)
    pdf.stroke_horizontal_rule
    pdf.move_down(20)
  
   xx = ShidouRec.find(session[:ext])    
   my_data = xx.map{|i| [i.date,i.desc, i.staff.name ] } 
    i = 0
   #pdf.text_options.update(:wrap => :character)  
   pdf.text_options.update(:wrap => :space)
   	  p = 250
   	  hh = 0
   for k in my_data
      tx0 = k[0]
   	  tx = k[1].cr0(25)[0].chomp #text contents
   	  tx3 = k[2]
   	  ln = k[1].cr0(25)[1] #lines
   	  mn = k[1].cr0(25)[2] #autocr
   	  h = (ln+1)*2.85 + 2.2
   	  p = p - hh
   	  hh = h
 
   	  pdf.cell [20.mm, p.mm],
        :width => 30.mm, :height => h.mm,
        :text  =>  tx0,
        :align => :left,
        :padding => 3,
        :text_color => 'cc0066',
        :font_size => 8
        
   	  pdf.cell [50.mm, p.mm],
        :width => 80.mm, :height => h.mm,
        :text  =>  tx + '|' + ln.to_s + '|' + mn.to_s,
        :align => :left,
        :padding => 3,
        :text_color => 'cc0066',
        :font_size => 8
        
   	  pdf.cell [130.mm, p.mm],
        :width => 40.mm, :height => h.mm,
        :text  =>  tx3,
        :align => :left,
        :padding => 3,
        :text_color => 'cc0066',
        :font_size => 8        
   end        
    
    
    
=begin
xx = ShidouRec.find(session[:ext])  
 my_data = xx.map{|i| [i.date, i.boy.id, i.boy.name, i.staff.name, i.cat, i.desc.cr(33) ] }
#my_data = xx.map{|i| [i.date, i.boy.id, i.boy.name, i.staff.name, i.cat, i.desc ] }
#pdf.text_options.update(:wrap => :character)

 pdf.table my_data,
    :font_size  => 8,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["日 付", "児童ID", "児童氏名", "指導員名", "分 類", "内 容"],
    :widths             => {0=>50, 1=>50, 2=>60, 3=>60, 4=>50, 5=>270 }
pdf.move_down(20)
pdf.stroke_horizontal_rule
pdf.text "innovative data design by EMU", :size => 8

=end