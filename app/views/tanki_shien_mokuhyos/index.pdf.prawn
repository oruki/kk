
#my_data = @tanki_shien_mokuhyos.map{|i| [i.id, i.kadai, i.mokuhyo, i.naiyou, i.hyoka ] }
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"

md = @my_data

pdf.instance_eval do
 #text_options.update(:wrap => :character, :size => 5)     
 text_options.update(:wrap => :spaces, :size => 8)   
  table md,
    #:font_size  => 12,
    :horizontal_padding => 4,
    :vertical_padding   => 4,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ID","支援上の課題","支援目標","支援内容・方法","評価（内容・期日）"],
    :widths             => {0=>60, 1=>110, 2=>110, 3=>110, 4=>110 }  
end  
 