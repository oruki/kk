=begin
pdf.instance_eval do
footer [margin_box.left, margin_box.bottom + 20] do
    stroke_horizontal_rule
    text "This is the footer"
  end

  table_data = []
  (1..60).each { |i| table_data << [i] }

  bounding_box bounds.top_left, :width => bounds.width, :height =>
bounds.height - 20 do
    table table_data
  end 
end



=end
require "prawn/measurement_extensions"
pdf.font "#{RAILS_ROOT}/public/ipag.ttf"

pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」＞児童一覧表", :size => 8
pdf.move_down(10)
    pdf.text "児童一覧表", :size => 12, :align => :center
    pdf.move_down(20)

#LOGO
 prawn_logo = "#{RAILS_ROOT}/public/images/sample.jpg"
 pdf.image prawn_logo, :at => [485,800], :width => 45
#----------------------------------------------------

           
pdf.move_down(10)


  sei = ["男","女"]
  my_data = @boys.map{
    |i| [
      i.id, i.name, i.kana_name, i.birthdate,
      i.birthdate.age, sei[i.sex - 1],
      i.status,
      i.staffs.map{|k| [k.name]}.join('/')
    ] 
  }

pdf.table my_data,
    :font_size  => 7,
    :horizontal_padding => 3,
    :vertical_padding   => 5,
    :position           => :center,
    :row_colors         =>["ffffff", "eeeeee"],
    :headers            => ["ID", "氏名","フリガナ","誕生日","年齢","性別","区分","指導員"]



pdf.move_down(20)

pdf.stroke_horizontal_rule
pdf.move_down(5)
pdf.text "児童福祉施設支援ｼｽﾃﾑ「大樹」", :size => 8, :align => :center


