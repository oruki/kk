pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞業務日誌", :size => 8
    period = "#{session[:yy]}-#{session[:mm]}"
    pdf.text "業務日誌（#{period}）", :size => 14, :align => :center   
    pdf.stroke_horizontal_rule
    pdf.move_down(20)
 
 # @day_recs
  my_data = @day_recs.map{|i| [i.id, i.hizuke, i.tenki, i.dekigoto, i.misc, i.staff.name ] }
pdf.text_options.update(:wrap => :character)
 pdf.table my_data,
    :font_size  => 6,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ID", "日付","天気","出来事","備考","記入者"],
    :widths             => {0=>32, 1=>40, 2=>20, 3=>330, 4=>70, 5=>38 }
pdf.move_down(20)
pdf.stroke_horizontal_rule
pdf.text "innovative data design by EMU", :size => 10