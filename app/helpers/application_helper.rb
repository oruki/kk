# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include CalendarHelper  



  def stretch_cillapse(x)
    "<span ID='show_icon01' style='margin-right:0px;float:right;'>
           #{stretch(x)}
           #{collapse(x)}                                
    </span>"
  end

  def stretch_collapse(x)
    "#{stretch(x)}
     #{collapse(x)}"
  end 
  
  
=begin
bb<% a=params[:controller] %>
bb<% b=params[:controller].singularize %>
<%= eval("@#{b}.staff.name") %>
<%= eval("@#{a}.size") %><br>
<% c=eval("@#{b}")%>

<%= eval("@#{b}.staff.name") %>
<%= eval("@#{a}.size") %><br>
<% c=eval("@#{b}")%>
<%= eval("@#{a}")[eval("@#{a}.index(@#{b})")+1].hizuke %>
   <%= link_to image_tag (
            'arrow_back.gif',
            :border=>0, 
            :title=>"前:"), 
          day_rec_path(@day_recs[eval("@#{a}.index(@#{b})")+1])%>
=end          
def go_prev(z="date")#time_start
c = params[:controller]
x = eval("@#{c}")
y = eval("@#{c.singularize}")
n = x.index(y)
p = x[n+1]

q = eval("p.#{z}")

if y!=x.last
link_to image_tag(
  'arrow_back.gif',
  :border=>0, 
  :title=>"前: #{q}"),
  eval("#{c.singularize}_path(p)")
end  
end
def go_next
c = params[:controller]
x = eval("@#{c}")
y = eval("@#{c.singularize}")
n = x.index(y)
p = x[n-1]
if y!=x.first
link_to image_tag(
  'arrow_next.gif',
  :border=>0, 
  :title=>'次:'),
  eval("#{c.singularize}_path(p)")
end
end









=begin ■　get_period
日付選択パネルのｙｙとｍｍの値をもとに抽出するデータの期間を算出する
=end

  def set_period_session
    if params[:year]      #params[:year]が設定されていない場合はyyを今年に設定する
      session[:yy] = params[:year]
    else
      session[:yy] ||= Date.today.strftime("%Y")      
    end
    if params[:month]     #params[:year]が設定されていない場合はmmを今月に設定する
      session[:mm] = params[:month]
    else
      session[:mm] ||= "tm"     
    end
    if params[:knd]
      session[:kk] = params[:knd]
    else
      session[:kk] ||= "shidou"
    end  
  end
  
  def session_to_obj(x = session[:kk])
  	case x
      when "school"
      	@school_recs
      when "med"
      	@med_recs
      when "stay_out"
      	@stay_out_recs
      else 
      	@shidou_recs
    end
  end
  
  def session_to_ctrl(x = session[:kk])
  	case x
      when "school"
      	"school_recs"
      when "med"
      	"med_recs"
      when "stay_out"
      	"stay_out_recs"   	
      else 
      	"shidou_recs"	
    end
  end	

  def session_to_partial(x = session[:kk])
  	case x
      when "school"
      	"school_recs2"
      when "med"
      	"med_recs2"
      when "stay_out"
      	"stay_out_recs2"   	
      else 
      	"shidou_recs2"
    end
  end
# 期間セレクタのｙ、ｍ値から期間（自至）を配列として求める  
  def get_period(y,m)
    now=Time.zone.now
    case m
      when "aa"
  	    ["#{y}-6-1".to_date.at_beginning_of_year.to_date,
  	    "#{y}-6-1".to_date.at_end_of_year.to_date]
      when "tm"
  	    [now.at_beginning_of_month.to_date,
  	    now.at_end_of_month.to_date]
      when "tw"
  	    [1.week.ago.to_date,
   	    now.at_end_of_week.to_date]
     when "td"	
  	    [now.to_date,now.to_date]
     else
     	["#{y}-#{m}-1".to_date,
    	"#{y}-#{m}-1".to_date.at_end_of_month.to_date]
    end
  end
  
 
    
  def to_status(x)
  	case x
  	when "10"
  		"在院"
  	when "00"
  		"退所"
  	else
  		''
  	end
  end	
  def date_jp
  	Time.zone.now.strftime( "%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.zone.now.wday]})")
  end

  def date_jpn(t)
  	t.strftime( "%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.zone.now.wday]})")
  end

  def table_grid
  	"<td style='visibility:visible;padding:5;background-color:red;'></td>" *32
  end
  
  def table_col(n)
  	 "<tr style='height:0px'>" + 
  	 "<td style='border:none 0px #555;visibility:hidden;padding:0;background-color:orange;'></td>" *n + 
  	 "</tr>"
  end
    
  #　■各ﾍﾟｰｼﾞの表題色帯■　id mst rec
  def title_bar(id,v)
  	"<TABLE ID=#{id} CLASS=title>
       <tr>
         <td>
           #{v}
         </td>
       </tr>  
    </TABLE>"
  end
  # 編集画面タイトルで対象レコードを表記するときボールドとしない
  def title_bar_2(id,v,w)
  	"<TABLE ID=#{id} CLASS=title>
       <tr>
         <td>
           #{v}
           <span style='font-size:12px; font-weight:normal'>
            #{w}
           </span>
         </td>
       </tr>  
    </TABLE>"
  end
  #　■各ﾍﾟｰｼﾞのアイコン機能帯■
  def fn_bar
  "<TABLE CLASS=part>
     <tr>
       <td style=text-align:right;>
         <span style=float:left>
           #{link_to_back}
         </span>  
         <span style=margin-right:20px>レコード数：#{@rec_count}件</span>
         #{link_to_mypage} &nbsp;
         #{go_new}
         #{link_pdf}
       </td>
     </tr>
  </TABLE>"
  end
  
  def fn_bar2
    "<TABLE CLASS=part>
      <tr>
        <td style=text-align:right>
        <span style=float:left>
          #{link_to_back}
        </span>
        #{link_to_mypage} &nbsp;
        #{go_list}
        </td>
     </tr>
    </TABLE>"
  end
    
  def fn_bar3(obj)
    "<TABLE CLASS=part>
      <tr>
        <td style=text-align:right>
        <span style=float:left>
          #{link_to_back}
        </span>
        #{link_to_mypage} &nbsp;
        #{go_edit(obj)} &nbsp;
        #{go_list}
        #{link_pdf_obj(obj)}
        </td>
     </tr>
    </TABLE>"
  end
  
# 使用しない方針（8.03）代替アクション=>link_pdf params[:action]をりようする  
  def link_to_pdf
  	case params[:controller]
  	  when "reports"
  	  	act = "hiyari_hat"
  	  else
  	  	act = "index"
  	end  		
    link_to image_tag("topdf.jpg", :border=>0, :title=>"PDF作成"),
          :controller => "#{session[:kk]}_recs",
          :action=> act,
          :year=>session[:yy],
          :month=>session[:mm],
          :format=>'pdf'
  end          
  
  
  def link_pdf_obj(obj)
  	link_to image_tag("topdf.jpg", :border=>0, :title=>"PDF作成"),
  	  :action => "show",
  	  :id => obj,
  	  :format => "pdf"
  end
  
  def link_pdf
  	x = params[:action]
    link_to image_tag("topdf.jpg", :border=>0, :title=>"PDF作成"), :action => x, :format => "pdf"
  end
   
  def slider(x)
	link_to image_tag("bll.GIF", :border=>1, :width=> x ,:height => 12 ), :action => "index"
  end	
	
  def link_new(x=params[:controller])
    link_to image_tag("action_add.gif", :border=>0, :title=>"新規作成"), :action => "new", :controller => x
  end
  
  def go_new()
    #link_to image_tag ("action_add.gif", :border=>0, :title=>"新規作成"), x
    link_to image_tag("action_add.gif", :border=>0, :title=>"新規作成"), :action => "new"
  end
  
  def go_edit(x, y = params[:controller])
    link_to image_tag("reply.gif", :border=>0, :title=>"編　集"), :controller => y, :action => "edit", :id => x
  end  
      
  def go_report(x)
    link_to image_tag("report.png", :border=>0, :title=>"表　示"), x
  end
   
  def go_list
    link_to image_tag("list.png", :border=>0, :title=>"リスト表示"), :action => "index"
  end
  
  def stretch (x)
    link_to_function image_tag("maximize.gif", :border=>0, :title=>"ひろげる") ,visual_effect(:appear, x)
  end

  def collapse(x)
    link_to_function image_tag("minimize.gif", :border=>0, :title=>"たたむ") ,visual_effect(:fade, x)
  end
  
  def link_to_path (x)
    link_to image_tag("list.png", :border=>0), x
  end

  def link_to_mypage(description = image_tag("user.gif", :border=>0, :title=>"マイページ"))
    if session[:attend]
      link_to description, session[:attend]
    end
  end

  #from marugotoRubyp.232
  def link_to_remote(name, options = {}, html_options = nil)
    spinner = options.delete(:spinner)
    if spinner
      options[:loading]  = "$('%s').show(); %s" % [spinner, options[:loading]]
      options[:complete] = "$('%s').hide(); %s" % [spinner, options[:complete]]
    end
    super
  end
    
  def link_to_back (description = image_tag("arrow_undo.png", :border=>0, :title => "&#12418;&#12393;&#12427;"))
    referer = request.env["HTTP_REFERER"]
    return false if !referer
    getIt = request.env["REQUEST_URI"].split("?")[1]
    if getIt.nil?
      getIt = ""
    else
      getIt = "?" + getIt if !getIt.match(/\?/)
    end
    link_to description, referer + getIt
  end
  
#■複数選択可能なチェックボックス入力
  def aaa(tmp,items,cont)
=begin
      	カテゴリーの入力をあらかじめ決めてある選択肢の中からチェックボックスで重複選択可能で入力させる
      	カテゴリー項目はここでなく別の設定ファイルから読み込む形としたい
      	include?メソッドにより現在のカテゴリーの値の有無をチェックしフォームに反映させている
      	これはreportの児童職員関係の入力画面と同じ方法だが_jido_list.htmlではindexメソッドを使っている
=end
      for item in items
        if cont
          flag = cont.include?(item)
        else
          flag = false
        end
        check_box_tag("#{tmp}", item, flag)
      end
  end
  
end

#---
# Excerpted from "Agile Web Development with Rails, 2nd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails2 for more book information.
#---
module BuilderHelper
  def tagged_form_for(name, *args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder => TaggedBuilder)
    args = (args << options)
    form_for(name, *args, &block)
  end
end

module DatePickerHelper
  def date_picker_field(object, method, show_suffixes = false, show_wday = false)
    days = %w{&#26085; &#26376; &#28779; &#27700; &#26408; &#37329; &#22303;}
    obj = instance_eval("@#{object}")
    value = obj.send(method)
    date_format = show_suffixes ? '%Y&#24180;%m&#26376;%d&#26085;' : '%Y/%m/%d'
    display_value = (value.respond_to?(:strftime) ? value.strftime(date_format) : value.to_s)
    if display_value.blank?
      display_value = '[ &#26085;&#20184;&#12434;&#36984;&#25246; ]' if display_value.blank?
    else
      display_value += value.respond_to?(:wday) ? ('(' + days[value.wday] + ')') : '' if show_wday
    end
    out = hidden_field(object, method)
    out << content_tag('a', display_value, :href => '#',
        :id => "_#{object}_#{method}_link", :class => '_demo_link',
        :onclick => "DatePicker.toggleDatePicker('#{object}_#{method}',#{show_suffixes},#{show_wday}); return false;")
    out << tag('div', :class => 'date_picker', :style => 'display: none',
                      :id => "_#{object}_#{method}_calendar")
    if obj.respond_to?(:errors) and obj.errors.on(method) then
      ActionView::Base.field_error_proc.call(out, nil) # What should I pass ?
    else
      out
    end
  end
end