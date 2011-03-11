module ReportsHelper
  def col_02(y,h,ttl,txt,max,f9,f8,f7)
    b1 = Prawn::Table::Cell.new(
      :point => [0.mm, y.mm],
      :border_width => 1, :padding => 1.mm, :width => 30.mm, :height => h.mm,
      :text => ttl, :font_size => 10, :align => :center,
      :document => self)   
    b2 = Prawn::Table::Cell.new(
      :point => [30.mm, y.mm],
      :border_width => 1, :padding => 1.mm, :width => 140.mm, :height => h.mm,
      :font_size => txt.fsize_by_chars2(f9,f8,f7,14),   
      #:font_size => 12.5,
      :text => txt.max_char(max),
      :document => self)
    b1.draw
    text_options.update(:wrap => :character)
    b2.draw  
  end
  def stamp_box(x, y, ttl)
  	bx1 = Prawn::Table::Cell.new(
      :point => [x.mm, y.mm],
      :border_width => 1, :padding => 1.mm, :width => 21.mm, :height => 6.mm,
      :text => ttl, :font_size => 10, :align => :center,
      :document => self)
  	bx2 = Prawn::Table::Cell.new(
      :point => [x.mm, (y-6).mm],
      :border_width => 1, :padding => 1.mm, :width => 21.mm, :height => 15.mm,
      :text => "", :font_size => 8,
      :document => self)
    bx1.draw
    bx2.draw      
  end		
end
