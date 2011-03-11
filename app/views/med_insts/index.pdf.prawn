pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞医療機関一覧表", :size => 8
pdf.move_down(10)
    pdf.text "医療機関一覧表", :size => 12, :align => :center
    pdf.move_down(20)

  sei = ["男","女"]
  my_data = MedInst.find(:all).map{|i| [i.id, i.cat, i.name, i.kana_name, i.zip, i.add, i.tel, i.fax] }

 pdf.table my_data,
    :font_size  => 6,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ID", "ｶﾃｺﾞﾘｰ","名称","フリガナ","郵便番号","住所","電話","ﾌｧｯｸｽ"]
    
pdf.move_down(20)

pdf.stroke_horizontal_rule
pdf.move_down(5)
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」", :size => 8, :align => :center