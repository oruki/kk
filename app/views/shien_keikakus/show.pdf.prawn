=begin ■ requirements and vals
=end
require "prawn/measurement_extensions"
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"

# 変数1
shutaru_mondai = @shien_keikaku.shutaru_mondai
shutaru_mondai||= "(未記入)"
honnin_ikou = @shien_keikaku.honnin_ikou
hogosha_ikou = @shien_keikaku.hogosha_ikou
school_iken = @shien_keikaku.school_iken
jidou_sodan_kyogi = @shien_keikaku.jidou_sodan_kyogi
shien_hoshin = @shien_keikaku.shien_hoshin

# 変数2
kari = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
inst_name = kari['inst_name']
seisakusha = @seisakusha
name="#{@boy.kana_name}\n#{@boy.name}"
sex=['○男','○女'][@boy.sex - 1]
birth="#{@boy.birthdate}（#{@boy.birthdate.age}歳）"
g_name=@boy.guardians[0].try(:name) if @boy.guardians
c_date=@shien_keikaku.created_at.to_date
zokugara=@boy.jido_guardian_rels[0].zokugara if @boy.jido_guardian_rels[0]

choki_01 = @shien_keikaku.choki_kodomo
choki_02 = @shien_keikaku.choki_katei
choki_03 = @shien_keikaku.choki_chiiki
choki_04 = @shien_keikaku.choki_sogo

=begin ■ moduleのミックスイン？
http://www.ruby-lang.org/ja/man/html/Object.html#extend
extend の機能は、「特異クラスに対する include」と言い替えることもできます。
=end
pdf.extend (ShienKeikakusHelper)
	
=begin テスト用コード

pdf.text_options.update(:wrap => :character)
      pdf.cell [160.mm,264.mm],
        :width => 38.mm, :height => 21.mm,
        :text  =>  "菜の花や月は東に日は西にな菜の花や"*9,
        :align => :right,
        :padding => 5,
        :text_color => 'cc0066',
        :font_size => 5
        
pdf.instance_eval do
    text_options.update(:wrap => :character, :size => 6)	
xx = Prawn::Table::Cell.new(  		
          :point =>[160.mm,264.mm],
          :border_width => 1, :padding => 2, :width => 38.mm, :height => 21.mm,
          :text => "菜の花や月は東に日は西にな菜の花や"*9,          
          :align => :left,
          :font_size => 6,
          :document => self)
xx.draw 
end
=end

=begin ■ aa:タイトル他
=end
pdf.instance_eval do
  stroke_rectangle [0.mm, 264.mm], 4.mm, 4.mm
  text "自 立 支 援 計 画 表",
    :align => :center, :size => 14, :at => [55.mm,245.mm] 
  text_options.update(:size => 9)
  ins = Prawn::Table::Cell.new(
    :point => [0.mm, 236.mm],
    :border_width => 0, :padding => 2, :width => 100.mm, :height => 6.mm,
    :text => "施設名：　#{inst_name}", :document => self)
  ins.draw
  auth = Prawn::Table::Cell.new(
    :point => [110.mm, 236.mm],
    :border_width => 0, :padding => 2, :width => 75.mm, :height => 6.mm,
    :text => "作成者名： #{seisakusha}", :document => self)
  auth.draw
end

=begin ■ bb-01:基本情報
=end
pdf.instance_eval do
#1	
  text_options.update(:wrap => :spaces, :size => 8)
  cell = Prawn::Table::Cell.new(
    :point => [0.mm, 230.mm],
    :border_width => 1, :padding => 2, :width => 24.mm, :height => 9.mm,
    :text => "ﾌﾘｶﾞﾅ\n子ども氏名", :document => self)
  cell.draw
  cell2 = Prawn::Table::Cell.new(
    :point => [24.mm, 230.mm],
    :border_width => 1, :padding => 2, :width => 38.mm, :height => 9.mm,
    :text => name, :document => self)
  cell2.draw
      
  cell3 = Prawn::Table::Cell.new(
    :point => [62.mm, 230.mm],
    :border_width => 1, :padding => 2, :width => 21.mm, :height => 9.mm,
    :text => "性別", :document => self)
  cell3.draw
  cell4 = Prawn::Table::Cell.new(
    :point => [83.mm, 230.mm],
    :border_width => 1, :padding => 2, :width => 18.mm, :height => 9.mm, 
    :text => sex, :document => self)
  cell4.draw    
    
  cell5 = Prawn::Table::Cell.new(
    :point => [101.mm, 230.mm],
    :border_width => 1, :padding => 2, :width => 21.mm, :height => 9.mm, 
    :text => "生年月日", :document => self)
  cell5.draw
  cell6 = Prawn::Table::Cell.new(
    :point => [122.mm, 230.mm],  
    :border_width => 1, :padding => 2, :width => 38.mm, :height => 9.mm, 
    :text => birth, :document => self)     
  cell6.draw
#2
  b01 = Prawn::Table::Cell.new(
    :point => [0.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 24.mm, :height => 9.mm,
    :text => "保護者氏名", :document => self)
  b01.draw
  b02 = Prawn::Table::Cell.new(
    :point => [24.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 38.mm, :height => 9.mm,
    :text => g_name, :document => self)
  b02.draw
      
  b03 = Prawn::Table::Cell.new(
    :point => [62.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 21.mm, :height => 9.mm,
    :text => "続柄", :document => self)
  b03.draw
  b04 = Prawn::Table::Cell.new(
    :point => [83.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 18.mm, :height => 9.mm, 
    :text => zokugara, :document => self)
  b04.draw
     
  b05 = Prawn::Table::Cell.new(
    :point => [101.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 21.mm, :height => 9.mm, 
    :text => "作成年月日", :document => self)
  b05.draw
  b06 = Prawn::Table::Cell.new(
    :point => [122.mm, 221.mm],
    :border_width => 1, :padding => 2, :width => 38.mm, :height => 9.mm, 
    :text => c_date, :document => self)
  b06.draw
#3
  text_options.update(:wrap => :character, :size => 8)
  c01 = Prawn::Table::Cell.new(
    :point => [0.mm, 212.mm],
    :border_width => 1, :padding => 2, :width => 24.mm, :height => 9.mm,
    :text => "主たる問題", :document => self)
  c01.draw
  #記述欄につき:wrap => :character
  text_options.update(:wrap => :character, :size => 8)
  c02 = Prawn::Table::Cell.new(
    :point => [24.mm, 212.mm],
    :border_width => 1, :padding => 2, :width => 136.mm, :height => 9.mm,
    :text => shutaru_mondai.max_char(92),
    :document => self)
  c02.draw

end

=begin ■ bb-02:４者意向
=end
pdf.instance_eval do
   bb_02(201,13,"本人の意向",honnin_ikou,265,103,158,182)	
   bb_02(188,13,"保護者の意",hogosha_ikou,265,103,158,182)	
   bb_02(175,13,"市町村・学校・保育所職場\nなどの意向",school_iken,265,103,158,182)
   bb_02(162,21,"児童相談所との協議内容",jidou_sodan_kyogi,473,208,278,366)

  h01 = Prawn::Table::Cell.new(
    :point => [0.mm, 141.mm],
    :border_width => 1, :padding => 2, :width => 160.mm, :height => 21.mm,
    :text => "【支援方針】#{shien_hoshin.max_char(384)}" ,:font_size => 6,
    :document => self)  
  h01.draw

end  
=begin フォントサイズの関係でタイトル欄と記述欄を別にレンダリングする
text_options.update(:wrap => :space, :size => 8)
  d01.draw
  e01.draw
  f01.draw
  g01.draw
text_options.update(:wrap => :character)
  d02.draw
  e02.draw
  f02.draw
  g02.draw
end 

=begin ■ cc-gg:支援計画策定
=end
pdf.instance_eval do
      i00 = Prawn::Table::Cell.new(
        :point => [0.mm, 120.mm],
        :border_width => 1, :padding => 5, :width => 160.mm, :height => 6.mm,
        :text => "第○回　支援計画の策定及び評価　　　　次期検討時期: ○○年○月",
        :font_size => 9,
        :document => self)
      i00.draw
end     
#cc-01
=begin ■　cc:子ども本人
=end
  cat = @shien_keikaku.tanki_shien_mokuhyos.scoped_by_cat('cat-01')
  cat_01 = cat.map{|c|[c.kadai, c.mokuhyo, c.naiyou, c.hyoka]}
  #RUBYでの多次元配列の宣言に注意
  cc01 = Array.new( 4, nil )
  cc01.each_index { |y|
  cc01[y] = Array.new( 4, 0 )
  }
pdf.instance_eval do
#title_cc
  title(114,"子ども本人")
  
#choki_cc
  choki(0,108,choki_01)

#th_cc
  th(95)
 
#sh_cc
  text_options.update(:wrap => :character)
  sh_cc = Prawn::Table::Cell.new(
    :point => [0.mm, 86.mm],
    :vertical_padding => 15.mm,
    :horizontal_padding => 6,
    :width => 8.mm, :height => 86.mm,
    :text => "短　期　目　標　∧優 先 的 重 点 的 課 題∨　",
    :font_size => 8,
    :align => :left,
    :document => self
  )
  sh_cc.draw
end
pdf.instance_eval do
  text_options.update(:wrap => :character)
  ptx = [8.mm,46.mm,84.mm,122.mm]
  pty = [86.mm, 64.5.mm, 43.mm, 21.5.mm]
  for k in 0..3
    ##cat_01[k]という配列要素が無い（空の）場合各要素に空白文字を代入する
    cat_01[k]||=['','','','']
    for j in 0..3
      cat_01[k][j]||= "(未記入)"
      text_options.update(:size => cat_01[k][j].change_font_size)
      cc01[k][j]=Prawn::Table::Cell.new(  		
        :point =>[ptx[j],pty[k]],
        :border_width => 1,
        :padding => 2, :width => 38.mm, :height => 21.5.mm,
        :text => cat_01[k][j].max_char(151),
        :align => :left,
        :document => self)
      cc01[k][j].draw    
    end      
  end
end

=begin ■■　ページ右側    
=end
#pdf.start_new_page
=begin ■　dd:家庭（養育者・家庭）
=end
  cat = @shien_keikaku.tanki_shien_mokuhyos.scoped_by_cat('cat-02')
  cat_02 = cat.map{|c|[c.kadai, c.mokuhyo, c.naiyou, c.hyoka]}
  #RUBYでの多次元配列の宣言に注意
  cc02 = Array.new( 3, nil )
  cc02.each_index { |y|
    cc02[y] = Array.new( 4, 0 )
  }
pdf.instance_eval do
  pdf.bounding_box([200.mm,246.mm], :width => 160.mm, :height => 91.mm) do
#title_dd
  title(91,"家庭（養育者・家族）")	

#choki_dd
  choki(0,85,choki_02)
    
#th_dd
  th(72)

#sh_dd
    text_options.update(:size => 8)
    dd20 = Prawn::Table::Cell.new(
      :point => [0.mm, 63.mm],
      :border_width => 1,
      :vertical_padding => 5.5.mm,
      :horizontal_padding => 6,
      :width => 8.mm, :height => 63.mm,
      :text => "短　期　目　標　∧優 先 的 重 点 的 課 題∨　",
      :font_size => 8,
      :align => :left,
      :document => self
    )
    dd20.draw
#TABLE_dd
    text_options.update(:wrap => :character)
    ptx = [8.mm,46.mm,84.mm,122.mm]
    pty = [63.mm, 42.mm, 21.mm]  
    for k in 0..2
      ##cat_02[k]という配列要素が無い（空の）場合各要素に空白文字を代入する
      cat_02[k]||=['','','','']
      for j in 0..3
        cat_02[k][j]||= "(未記入)"
        text_options.update(:size => cat_02[k][j].change_font_size)
        cc02[k][j]=Prawn::Table::Cell.new(
          :point =>[ptx[j],pty[k]],
          :border_width => 1, :padding => 2, :width => 38.mm, :height => 21.mm,
          :text => cat_02[k][j].max_char(151),
          :align => :left,
          :document => self)
        cc02[k][j].draw    
      end      
    end

  end
end 

=begin ■　ee:地域（保育所・学校等）
=end
  cat = @shien_keikaku.tanki_shien_mokuhyos.scoped_by_cat('cat-03')
  cat_03 = cat.map{|c|[c.kadai, c.mokuhyo, c.naiyou, c.hyoka]}
  #RUBYでの多次元配列の宣言に注意
  cc03 = Array.new( 2, nil )
  cc03.each_index { |y|
    cc03[y] = Array.new( 4, 0 )
  }
pdf.instance_eval do
  pdf.bounding_box([200.mm,155.mm], :width => 160.mm, :height => 70.mm) do
#title_ee
  title(70,"地域（保育所・学校等）")	

#choki_ee
  choki(0,64,choki_03)

#th_ee
  th(51)

#sh_ee
    text_options.update(:size => 7)
    sh_ee = Prawn::Table::Cell.new(
      :point => [0.mm, 42.mm],
      :vertical_padding => 0.9.mm,
      :horizontal_padding => 6,
      :width => 8.mm, :height => 42.mm,
      :text => "短期目標∧優先的重点的課題∨",
      :font_size => 8,
      :align => :left,
      :document => self
    )
    sh_ee.draw
    
#TABLE_ee   
    text_options.update(:wrap => :character)
    ptx = [8.mm,46.mm,84.mm,122.mm]
    pty = [42.mm, 21.mm]  
    for k in 0..1
      ##cat_03[k]という配列要素が無い（空の）場合各要素に空白文字を代入する
      cat_03[k]||=['','','','']
      for j in 0..3
        cat_03[k][j]||= "(未記入)"
        text_options.update(:size => cat_03[k][j].change_font_size)      	
        cc03[k][j]=Prawn::Table::Cell.new(  		
          :point =>[ptx[j],pty[k]],
          :border_width => 1, :padding => 2, :width => 38.mm, :height => 21.mm,
          :text => cat_03[k][j].max_char(151),            
          :align => :left,
          :document => self)
        cc03[k][j].draw    
      end      
    end   
  end        
end 

=begin ■　ff:総　合
=end
  cat = @shien_keikaku.tanki_shien_mokuhyos.scoped_by_cat('cat-04')
  cat_04 = cat.map{|c|[c.kadai, c.mokuhyo, c.naiyou, c.hyoka]}
  #RUBYでの多次元配列の宣言に注意
  cc04 = Array.new( 2, nil )
  cc04.each_index { |y|
    cc04[y] = Array.new( 4, 0 )
  }

pdf.instance_eval do
  pdf.bounding_box([200.mm,85.mm], :width => 160.mm, :height => 70.mm) do
#title_ff
  title(70,"総　合")

#choki_ff
  choki(0,64,choki_04)

#th_ff
  th(51)

#sh_ff
    text_options.update(:size => 7)
    sh_ff = Prawn::Table::Cell.new(
      :point => [0.mm, 42.mm],
      :vertical_padding => 0.9.mm,
      :horizontal_padding => 6,
      :width => 8.mm, :height => 42.mm,
      :text => "短期目標∧優先的重点的課題∨",
      :font_size => 8,
      :align => :left,
      :document => self      
    )
    sh_ff.draw 
#TABLE_ff    
    text_options.update(:wrap => :character)
    ptx = [8.mm,46.mm,84.mm,122.mm]
    pty = [42.mm, 21.mm]  
    for k in 0..1
      #cat_04[k]という配列要素が無い（空の）場合各要素に空白文字を代入する
      cat_04[k]||=['未記入','未記入','未記入','未記入']
      for j in 0..3
        cat_04[k][j]||= "(未記入)"
        text_options.update(:size => cat_04[k][j].change_font_size)
        cc04[k][j]=Prawn::Table::Cell.new(  		
          :point =>[ptx[j],pty[k]],
          :border_width => 1, :padding => 2, :width => 38.mm, :height => 21.mm,
          :text => cat_04[k][j].max_char(151),          
          :align => :left,
          :document => self)
        cc04[k][j].draw    
      end      
    end

  end       
end 

=begin ■　gg:特記事項
=end
pdf.instance_eval do
      g00 = Prawn::Table::Cell.new(
        :point => [200.mm, 15.mm],
        :border_width => 1, :padding => 5, :width => 160.mm, :height => 15.mm,
        :text => "【特記事項】",
        :document => self)
      g00.draw
end 
