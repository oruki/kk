module ShienKeikakusHelper
	
  def tamesi
    text "hello"*8
  end
  
  def inss
  	uu="what a beautiful day"*2
    ins = Prawn::Table::Cell.new(
      :point => [55.mm, 236.mm],
      :border_width => 0, :padding => 2, :width => 80.mm, :height => 6.mm,
      :text => uu, :document => self)
    ins.draw
  end
  
  def bb_02(y,h,ttl,txt,max,f9,f8,f7)
    b1 = Prawn::Table::Cell.new(
      :point => [0.mm, y.mm],
      :border_width => 1, :padding => 10, :width => 45.mm, :height => h.mm,
      :text => ttl, :font_size => 8,
      :document => self)   
    b2 = Prawn::Table::Cell.new(
      :point => [45.mm, y.mm],
      :border_width => 1, :padding => 2, :width => 115.mm, :height => h.mm,
      :font_size => txt.fsize_by_chars(f9,f8,f7),    
      :text => txt.max_char(max),
      :document => self)
    text_options.update(:wrap => :space, :size => 9)  
    b1.draw
    text_options.update(:wrap => :character)
    b2.draw  
  end
  
  
  
  def title(y,ttl)
    t = Prawn::Table::Cell.new(
      :point => [0.mm, y.mm],
      :border_width => 1, :padding => 5, :width => 160.mm, :height => 6.mm,
      :text => ttl, :align => :center,
      :font_size => 8,
      :background_color =>'cccccc',
      :document => self
    )
    t.draw
  end
  
  def choki(x,y,txt)
      d_0 = Prawn::Table::Cell.new(
        :point => [x.mm, y.mm],
        :borders => [:top,:left,:bottom],
        :padding => 5, :width => 16.mm, :height => 13.mm,
        :text => "長期目標", :font_size => 8,
        :document => self)
      if txt
      	t = txt.max_char(328)
      else
      	t = " "
      end	
      d_1 = Prawn::Table::Cell.new(
        :point => [x+16.mm, y.mm],
        :borders => [:top,:right,:bottom],
        :padding => 3, :width => 144.mm, :height => 13.mm,
        :text => t, 
        :font_size => txt.fsize_by_chars(127,194,222), 
        :document => self)
      d_0.draw
      d_1.draw
  end
  
  def th(y)
    pt = [[0.mm, y.mm],[8.mm, y.mm],[46.mm, y.mm],[84.mm, y.mm],[122.mm, y.mm]]
    wd = [8.mm,38.mm,38.mm,38.mm,38.mm]
    tx = ['','支援上の課題','支援目標','支援内容・方法','評価（内容・期日）']
    th = []
    text_options.update(:wrap => :character)
    for i in 0..4
      th[i] = Prawn::Table::Cell.new(
        :point => pt[i],
        :border_width => 1, :padding => 5, :width => wd[i], :height => 9.mm,
        :text => tx[i],
        :font_size => 8,
        :align => :center,
        :document => self)	
      th[i].draw
    end
  end
  
end