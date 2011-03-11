pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞児童一覧表", :size => 8

    pdf.text "児童の一覧表", :size => 25, :align => :center   
    pdf.stroke_horizontal_rule
    pdf.move_down(20)

  sei = ["男","女"]
  my_data = Boy.find(:all).map{|i| [i.id, i.name, i.kana_name, i.birthdate, i.birthdate.age, sei[i.sex - 1]] }

 pdf.table my_data,
    :font_size  => 8,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ID", "氏名","フリガナ","生年月日","年齢","性別"]
pdf.move_down(20)
pdf.stroke_horizontal_rule
pdf.text "And here's a sexy footer", :size => 16