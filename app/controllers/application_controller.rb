PREF = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
# 天気入力用の選択アイテムを設定ファイルから読み込み定数TENKIに代入
TENKI = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")['weather'].split

INST_NAME = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")['inst_name']

=begin rdoc
date:: 2009-06-10
author:: yasui
==アプリケーションコントローラー
0. 
* Filters added to this controller apply to all controllers in the application.
* Likewise, all the methods added will be available for all controllers
1. 加えた変更の記録
   * ＰＤＦファイル出力用「'prawn/layout'」これはテーブル関連モジュールが分離されたため宣言が必要
   * before_filter としてセッション持続時間をチェックする「:timecheck」クラスを追加
   * gettextを外す
2. Stringクラス拡張クラスなど後方に定義を追加
3. Zipファイル書出し
 
=end
class ApplicationController < ActionController::Base
  before_filter :timecheck  # 2009.06.07 added next line
  require 'prawn/layout'
# require 'prawn/core'   
  include ApplicationHelper
# Added 2008.06.10 same line should be commentouted in session controller.rb  
  include AuthenticatedSystem
#  helper :all # include all helpers, all the time

=begin rdoc ■　各記録コントローラーで共有するアクション
selects_controllerから移動する
=end


  def super_join(x)
  	if x
  		x=x.join(',')	
  	else
  		x=nil
  	end
  end		
  		


=begin ■next_index
called:attend_controller
    @next = next_index(@attend)	#配列のひとつ後の要素の位置
    @prev = prev_index(@attend)	#配列のひとつ前の要素の位置
=end

  
# attend記録の日順ﾅﾋﾞｹﾞｰﾄﾎﾞﾀﾝ 配列@attendsの中で値がxである最初の要素の位置==@attends.index(x)
  def next_index(x,y=@attends)
    y.index(x) - 1
  end
  def prev_index(x,y=@attends)
    y.index(x) + 1
  end
  
  
  
  
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

=begin ■　期間のセッション
given session[:kk]

=end
  def get_session_ext_of_attend(n, boy_ids, x=@attend)
    d1 = x.time_start.advance(:days => -n) .to_date
    d2 = x.time_start.to_date      
    case session[:kk]
      when "shidou"
        @shidou_recs = ShidouRec.between_dates(d1,d2).selected_boys(boy_ids)
        session[:ext] = @shidou_recs.map{|i| i.id} if @shidou_recs
      when "school"
        @school_recs = SchoolRec.between_dates(d1,d2).selected_boys(boy_ids)
        session[:ext] = @school_recs.map{|i| i.id} if @school_recs
      when "med"
        @med_recs = MedRec.between_dates(d1,d2).selected_boys(boy_ids)
        session[:ext] = @med_recs.map{|i| i.id} if @med_recs
      when "stay_out"
        @stay_out_recs = StayOutRec.between_dates(d1,d2).selected_boys(boy_ids)
        session[:ext] = @stay_out_recs.map{|i| i.id} if @stay_out_recs
      else 
    end
  end
 




  def set_grp_rec
    x= params[:id]
  	session[:three_days]=params[:three_days]
  	session[:all_grp]=params[:all_grp]
  	session[:three_days]||='0'
  	session[:all_grp]||='0'
  	#redirect_to :back
  	if session[:three_days]=='1'
  	  if session[:all_grp]=='0'
        session[:ext0] = GroupRec.of_attend_dates(x,3).of_attend_grp(x).map{|i| i.id}
      else
      	session[:ext0] = GroupRec.of_attend_dates(x,3).map{|i| i.id}
      end
    else
  	  if session[:all_grp]=='0'
        session[:ext0] = GroupRec.of_attend_dates(x,0).of_attend_grp(x).map{|i| i.id}
      else
      	session[:ext0] = GroupRec.of_attend_dates(x,0).map{|i| i.id}
      end
    end
    @group_recs = recs("group_rec","hizuke")
    @group_recs_cnt = @group_recs.size 
    recs_rjs2("group_recs") 
  end

=begin rdoc ■
各記録ビューに共通なajaxでインラインビュー
=end

  def recs_rjs3(ctrl, recs_size) #記録（*_recs）の名前/件数/ＤＯＭのＩＤ	
  	render :update do |page|
      page.replace_html(
        "#{ctrl}",
        :partial => "shared/#{ctrl}",
        :object => eval("@#{ctrl}"))
      page.replace_html("recnbr_for_grp_recs", "レコード件数：#{recs_size}件")      
      page["recnbr_for_grp_recs"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"  
      page["#{ctrl}"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"
    end 
  end

#master tableにも適用する？
  def recs_rjs_boy(recs_name)
  	render :update do |page|
      page.replace_html(
        "#{recs_name}",
     #   :partial => "shared/#{recs_name}2",
         :partial => "#{recs_name}",
        :object => eval("@#{recs_name}"))
   #   page.replace_html(:recnbr, "レコード件数：#{session[:ext].size}件")
   #   page[:recnbr].visual_effect :highlight,:startcolor => "#88ff88",:endcolor => "#ffff99" 
      page["#{recs_name}"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"
    end 
  end



  def recs_rjs2(recs_name)
  	if recs_name == "group_recs"
  	  rec_nbr = session[:ext0].size
  	  pos = :recnbr_for_grp_recs
  	else
  	  rec_nbr = session[:ext].size
  	  pos = :recnbr
  	end		
  	render :update do |page|
      page.replace_html(
        "#{recs_name}",
        :partial => "shared/#{recs_name}",
        :object => eval("@#{recs_name}"))
#     page.replace_html (:recnbr, "レコード件数：#{rec_nbr}件")
      page.replace_html(pos, "レコード件数：#{rec_nbr}件")      
      page["recnbr_for_grp_recs"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"  
      page["#{recs_name}"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"
    end 
  end	
=begin ■経過的な処置
コード変更の都合でshared/shidou_recs2のようにrec_name(shidou_rec)に2を追加した部分テンプレート名称となっているので
変則的なコードが書かれている。結果上記のrecs_rjs2は専用アクションとなっている
=end
  def recs_rjs(recs_name)
  	render :update do |page|
      page.replace_html(
        "#{recs_name}",
        :partial => "shared/#{recs_name}2",
        :object => eval("@#{recs_name}"))
      page.replace_html(:recnbr, "レコード件数：#{session[:ext].size}件")
      page[:recnbr].visual_effect :highlight,:startcolor => "#88ff88",:endcolor => "#ffff99" 
      page["#{recs_name}"].visual_effect :highlight,:startcolor => "#ff9900",:endcolor => "#ffff99"
    end 
  end
  
=begin ■ recs 各記録モジュールで指導員、児童での絞り込み
   #session[:ext] is set in controller/index
   #session[:ext] is set again after this action
   #@*_recs can be accessed by finding session
  def recs(x)
    model_name = {
      "shidou" => "ShidouRec", "school" => "SchoolRec",
      "med" => "MedRec", "stay_out" => "StayOutRec", "group_rec" => "GroupRec"}  
    p = eval(model_name[x]).find(session[:ext]) 
    p = p.select {|i| i.boy_id.to_s   == params[:boy]} if params[:boy]
    p = p.select {|i| i.staff_id.to_s == params[:staff]} if params[:staff]
    p = p.sort {|x, y| y.date <=> x.date}   #日付で降順ソート
    session[:ext] = p.map{|i| i.id}
    return p	  	                       
  end  
=end


  def recs(m,sort_key="date") #受け取るパラメーターで相当するフィールドをキーに絞込みをかけるまたｙでソートする
    model_name = {
      "shidou" => "ShidouRec",
      "school" => "SchoolRec",
      "med" => "MedRec",
      "stay_out" => "StayOutRec",
      "group_rec" => "GroupRec",
      "boy" => "Boy"
      }
    case m
      when "group_rec"
        p = eval(model_name[m]).find(session[:ext0])
      when "boy"
      	p = Boy.all
      else 	
        p = eval(model_name[m]).find(session[:ext])
    end
    
    p = p.select{|i| i.sex.to_s   == params[:sex]} if params[:sex]
    p = p.select{|i| i.boy_id.to_s   == params[:boy]} if params[:boy]
    p = p.select{|i| i.staff_id.to_s == params[:staff]} if params[:staff]
 
    p = p.select{|i| i.group_id.to_s == params[:group]} if params[:group]
    # カテゴリーが記入されているレコード抽出更にそのカテゴリーにパラメーター（クリックしたカテゴリー値）を含むもののみ抽出）    
    p = p.select{|i| i.cat}.select{|j| j.cat.index(params[:cat])} if params[:cat]
    
    p = p.select{|i| i.boy.groups.map{|i| i.name}.index(params[:grp])}if params[:grp]
    
#   p = p.select{|i| i.cat.index(params[:cat]) != nil} if params[:cat]
    
    p = p.sort {|x, y| eval("y.#{sort_key}") <=> eval("x.#{sort_key}")}   #日付で降順ソート
    session[:ext] = p.map{|i| i.id}  unless m == "group_rec"
    session[:ext0] = p.map{|i| i.id}  if m == "group_rec"
    return p	  	                       
  end 
  
  def boys_list
  	@boys = recs("boy","birthdate")
    @boys_cnt = @boys.size   
    recs_rjs_boy("boys")  
  end	
  
  def group_rec
  # session[:ext] = GroupRec.of_attend_dates(@attend,3).of_attend_grp(@attend)
    @group_recs = recs("group_rec","hizuke")
    @group_recs_cnt = @group_recs.size   
   # recs_rjs3("group_recs", session[ext0].size)
    recs_rjs2("group_recs")
  end  
 # recs_rjs3(recs_name, recs_size, dom_id ) #記録（*_recs）の名前/件数/ＤＯＭのＩＤ	
  
=begin
below actions hit to stay_out need rendering action named "recs_rjs" not "recs_rjs2" where partial names are arranged being added suceeding numeric letter "2". You will notice the action change seeing hilighting color differrence.
=end
  def hit
    @shidou_recs = recs("shidou")
    @shidou_recs_cnt = @shidou_recs.size   
    recs_rjs("shidou_recs")    
  end

  def kick
    @school_recs = recs("school")
    @school_recs_cnt = @school_recs.size
    recs_rjs("school_recs") 
  end

  def med
    @med_recs = recs("med")
    @med_recs_cnt = @med_recs.size
    recs_rjs("med_recs")   
  end
  
  def stay_out
    @stay_out_recs = recs("stay_out")
    @stay_out_recs_cnt = @stay_out_recs.size
    recs_rjs("stay_out_recs") 
  end
  
    
  private

# 認証プラグイン（）
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice]= "ログインして下さい(auth)"
      redirect_to(:action => 'logout' )
    end
  end
=begin rdoc ■　セッションタイムアウト
# date::2009.06.07
# ====一定時間でセッションタイムアウトを実行
=end
  def timecheck
    k = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")['session_period']
    session[:timecheck] ||= Time.zone.now
    elapsed = (Time.zone.now - session[:timecheck]).round
    if elapsed.round > k
      reset_session()
    #  flash[:notice] = "#{elapsed} 秒以上経ったのでﾛｸﾞｱｳﾄしました(制限秒数:#{k})"
      redirect_to(:controller => 'sessions', :action => 'new')
    else
      session[:timecheck] = Time.zone.now
    #  flash[:notice] = "#{elapsed} 秒経過 (制限秒数:#{k})"
    end		
  end

end

=begin rdoc
===Stringクラスの拡張
* 日本語ﾃｷｽﾄを特定の文字数で改行する
* PDF出力用ﾌﾟﾗｸﾞｲﾝ（prawn/prawnto）で必要となる
* 継承が機能しているかﾁｪｯｸを行い正常ならｻﾌﾞｸﾗｽでの実装を中止する
param:: n each n-th count you get \n ie carrige return or kaigyo
return:: string with \n　改行記号を追加したテキストを生成する
=end
=begin rdoc ■　Nil
- max_char fsize_by_chars(x,y,z)はストリングクラスを拡張している
- nil.fsize_by_chars(x,y,z)でNilClassのダミーを作りエラーを避ける
- 弊害があるかもしれないので検討
=end
class NilClass
  def max_char
  end
	
  def fsize_by_chars(x,y,z)
  end
  
  def cr(x)
  end	
end



class String
=begin rdoc ■　
===支援計画短期目標のカテゴリー
- コードに対応する用語を割り当てる
=end	
	def cat_to_str
		case self
		when "cat-01"
			" 子ども本人"
		when "cat-02"
			" 家　庭"
		when "cat-03"
			" 地　域"
		when "cat-04"
			" 総　合"		
		else
			""	
		end								
	end	
=begin rdoc ■　
==テキストの文字数に対応して使用するフォントの大きさを変化させる
- font wh in choki
*  9  43  3  129  127
*  8  49  4  196  194
*  7  56  4  224  222
*  6  66  5  330  328
- font w h in shien_keikaku
-  9  35  3  105  103
-  8  40  4  160  158
-  7  46  4  184  182
-  6  53  5  153  265
- font w h
-  9  35  6  210  208
-  8  40  7  280  278
-  7  46  8  368  366
-  6  53  9  477  475
- font w h
-  9  11  6   66  64
-  8  13  7   91  89
-  7  14  8  112 110
-  6  17  9  153 151
=end
  def fsize_by_chars(x,y,z)
    case self.jlength
    when 0..x
      9
    when x+1..y
      8
    when y+1..z
      7
    else
      6
    end
  end
 
  def fsize_by_chars2(x,y,z,mx=9)
    case self.jlength
    when 0..x
      mx
    when x+1..y
      mx-1
    when y+1..z
      mx-2
    else
      mx-3
    end
  end
  
    
#=change_font_size
#*入力文字数におうじて文字のポイントを段階的に変化させる
  def change_font_size
    case self.jlength
    when 0..64
      9
    when 65..89
      8
    when 90..110
      7
    else
      6
    end
  end
    
=begin 最大文字制限 
出典：http://doruby.kbmj.com/honda_on_rails/20080131/1
=end
  def max_char(n)
  	if self.jlength < n
  		self
  	else
  		self.scan(/^.{#{n}}/m)[0] + "…"
  	end	
  end

#改行　その１
  def dr(n)
    k = self.jsize.div(n)
    s = ""
    for i in 0..k 
    	s = s + self[i*n .. (i+1)*n-1] + "\n"
    end  
  end
  
=begin rdoc ■　改行表示
====改行表示
- stringに指定桁（文字）数で折り返すようにメッセージを送る
=end
  def kaigyo(n)
    st=""
    i = 0
    self.each_char do |x|
      i = i + 1
      if i%n == 0 
        st = st + "#{x}\n"
      else
        st = st + x
      end
    end  
    return st
  end
  
=begin rdoc ■　改行表示 禁則処理
====改行表示
- stringに指定桁（文字）数で折り返すようにメッセージを送る
- 禁則処理を追加
=end
  def cr0(n)
    st= ""
    i = 0     #カウンター初期値０
    k = 0
    mn = 0
    ln = 0    #行数初期値０
    self.each_char do |x|	
      k += 1
      i += 1 
      #禁則処理 「、」を加えると誤表示ありとりあえず除外する（2009.7.13）
      if "。）」".index(x) and i == 1
      	st[-1,1] = x     #既にある末尾の改行記号をXに置き換え
      	st = st + "\n"   #そのあとで改行する
      	next
      end	
          
      if i%n == 0
      	if x == "\n" 
          st = st + "\n"
        else
          st = st + x + "\n"
        end 
        i = 0
        ln += 1
      elsif x == "\n" 
      	if k != self.jlength
      	  st = st + "\n"
          i = 0
          ln += 1
          mn += 1
        end  
      else
      	st = st + x 
      end
    end
    return [st, ln, mn]
  end  

#改行　その２
  def cr(n)
    st=""
    i = 0
    self.each_char do |x|
      i = i + 1
      if i%n == 0 
#       st = st + "#{x}\n"
        st = st + x + "\n"
      else
        st = st + x
      end
    end  
    return st
  end
#改行　その３
  def hln(n)
    st=""
    i = 0
      if self.jsize > n
        self.each_char do |x|
          i = i + 1
          st = st + x
          if i > n
            return st+"..."
          end
        end
      else
        return self
      end
  end
end

=begin rdoc
====Integerクラスの拡張
* 2008.12.16 数字を１なら男２なら女に変換する
=end
class Integer
#* 2008.12.16 数字を１なら男２なら女に変換する
  def to_jsex
    case self
    when 1
      '男'
    when 2
      '女'
    else
      nil
    end  
  end
end
	
=begin rdoc
===Dateクラスの拡張
* 2008.08.04 'if self'added  check needed to work?
=end
class Date
=begin rdoc
====引数に日付を与えその時点の年齢を計算する
=end
  def age(calcDay = Time.now)
    (calcDay.strftime("%Y%m%d").to_i-self.strftime("%Y%m%d").to_i)/10000 if self
  end
=begin rdoc
====引数に現在の年を与え４月１日時点の学齢を計算する
=end
  def age2(calcDay = "#{Time.now.year}-4-1 0:0:0".to_date)
    t=(calcDay.strftime("%Y%m%d").to_i-self.strftime("%Y%m%d").to_i)/10000 if self
    case t
	when 0..5
		"未就学児童"
	when 6..11
		"小学#{t-5}年"
	when 12..14
		"中学#{t-11}年"
	when 15..17
		"高校#{t-14}年"
	when 18..21
		"大学生#{t-17}年"
	else
		"その他"
	end			
  end

=begin rdoc
====日本語の日付に変更する
=end 
  def to_jdate
  	self.strftime( "%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[self.wday]})" )
  end  
end

=begin rdoc
===Timeクラスの拡張
- 2008.08.04 'if self'added  check needed to work?
- 引数onで与えられた過去時間からの経過秒数
=end
class Time
  def dif_time(on)
    (self.sec.to_i - on.sec.to_i)/3600.to_i
  end
end


