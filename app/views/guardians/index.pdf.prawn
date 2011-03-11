pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞保護者一覧表", :size => 8
pdf.move_down(10)
    pdf.text "保護者一覧表", :size => 25, :align => :center   
    pdf.stroke_horizontal_rule
    pdf.move_down(20)

  sei = ["男","女"]
  my_data = Guardian.find(:all).map{ |i| [
            "#{i.kana_name} \n#{i.name}",
            "#{i.birth_date} #{i.birth_date.age} #{%w{性 男 女}[i.sex]}",
            "#{i.occupation} / #{i.cond_income}",
            i.cond_health, 
            "#{i.tel} \n#{i.tel_hp}",
            i.misc ]}

 pdf.table my_data,
    :font_size  => 7,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ﾌﾘｶﾞﾅ/氏名", "年齢･性別･生年月日","職　業/収　入","健康状態","電　話/携　帯","備　考"]
    
pdf.move_down(20)

pdf.stroke_horizontal_rule
pdf.text "innovative solutions by EMU", :size => 10