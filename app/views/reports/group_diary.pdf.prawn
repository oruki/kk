=begin ■ requirements and vals
ReportsHelper
　　def col_02(y,h,ttl,txt,max,f9,f8,f7)
=end
# settings
require "prawn/measurement_extensions"

pdf.font "#{RAILS_ROOT}/public/ipag.ttf"
# 変数2
kari = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
inst_name = kari['inst_name']
=begin ■ moduleのミックスイン？
http://www.ruby-lang.org/ja/man/html/Object.html#extend
extend の機能は、「特異クラスに対する include」と言い替えることもできます。
=end

pdf.extend (ReportsHelper)
=begin ■ moduleのミックスイン？
=end
#  my_data = session[:ext].map{|i| ShidouRec.find(i)}.map{
#    |i| [i.date.to_s, i.boy.name, i.basho, i.desc.cr0(30)[0], i.taisaku, i.staff.name ]
#  }
  
  my_data = session[:ext].map{|i| ShidouRec.find(i)}.map{
    |i| [i.date.to_s, i.boy.name, i.basho, i.desc, i.taisaku, i.staff.name ]
  }  
  
 cnt=0
pdf.instance_eval do
  for i in my_data
    i[2]||="?"
    i[3]||="?"
    i[4]||="?"
  pdf.start_new_page unless i == my_data.first
  pdf.text "ヒヤリハットメモ", :at => [5.mm,120.mm], :size => 18

# layout for table inside bb
  bounding_box bounds.top_left,:width => bounds.width,:height => bounds.height - 8 do

    text_options.update(:wrap => :spaces, :size => 12)
    stamp_box(86, 125, "院　長")
    stamp_box(107, 125, "副院長")
    stamp_box(128, 125, "部　長")
    stamp_box(149, 125, "記入者")
  
=begin
      col_02(8,8,"報　告　日","txt",100,50,80,120)
=end

      col_02(96,8,"日　　　時",i[0],100,50,80,120)
      col_02(88,8,"児　童　名",i[1],100,50,80,120)
      col_02(80,8,"場　　　所",i[2],100,50,80,120) if i[2]
      col_02(72,24,"内　　　容",i[3],173,106,148,158) if i[3]
      col_02(48,40,"今後の対策",i[4],348,214,268,286) if i[4]
      col_02(8,8,"報　告　日",i[0],50,27,30,40)

    end
  
  
  end 
end  