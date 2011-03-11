pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞指導員一覧表", :size => 8
pdf.move_down(10)
    pdf.text "指導員一覧表", :size => 12, :align => :center
    pdf.move_down(20)

  sei = ["男","女"]
  my_data = Staff.find(:all).map{
    |i| ["#{i.id}\n#{i.shokumei}", "#{i.kana_name}\n#{i.name}", i.birth_date, i.birth_date.age, sei[i.sex - 1],
         "#{i.resd_add}\n#{i.per_add}", i.tel, i.tel_hp
         ] }

 pdf.table my_data,
    :font_size  => 8,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            =>["ID/職名", "フリガナ/氏名", "生年月日", "年齢", "性別", "住所/本籍", "電話番号", "携帯番号"],
    :widths             => {0=>65, 1=>85, 2=>50, 3=>20, 4=>20, 5=>120, 6=>80, 7=>80 }
    
pdf.stroke_horizontal_rule
pdf.move_down(5)
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」", :size => 8, :align => :center    