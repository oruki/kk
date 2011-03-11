=begin rdoc
====Attends ｺﾝﾄﾛｰﾗｰ
date:: 2008.09.16
author:: yasui
* 指導員の出勤管理のためのコントローラー
* 指導員各々が日毎ﾛｸﾞｲﾝした時点で出勤記録を作成する
* ある指導員のある日に１つのattendｲﾝｽﾀﾝｽが作成される（ﾀｲﾑｶｰﾄﾞのようなもの）
* :url=>attend/id(:action=>"show")が指導員の「ﾏｲﾍﾟｰｼﾞ」となる
=end

class AttendsController < ApplicationController
# authentification 2008.06.10
  before_filter :login_required
  
  def show02
  	@attend = Attend.find(params[:id])
  	b=Boy.all.map{|k|k.id}
  	if params[:knd]
  		set_period_session
  		get_session_ext_of_attend(session[:days_to_show].to_i,b, @attend)
  	end	
    if params[:days_to_show]
  		set_period_session
  		get_session_ext_of_attend(params[:days_to_show].to_i,b, @attend)
  		session[:days_to_show] = params[:days_to_show]
  	end	
  end
  
  
  	
  def linko
    render :update do |page|
      page.replace_html("dog", render(:partial => 'linchan', :locals => {}))
    end 
  
  end
  
  def reg_date
  	aa = "#{Date.today.to_s} #{params[:thetime]}".to_time
   #@attend=Attend.find(params[:id])
    #@attend.time_start = aa
    @kate=aa
    session[:ttest]=aa
  end
  

  
  def show_hh
    render :update do |page|
      page.replace_html("baby", render(:partial => 'selecthh', :locals => {}))
    end 
  end
  
  #:hh 選択された時間　:id　表示部分のDOM ID
  def show_mm
    case params[:kubun]
      when "workon"
      	session[:hh]=params[:hh]
        render :update do |page|
          page.replace_html(params[:kubun], render(:partial => 'setmm', :locals => {:hh => params[:hh],:kb=>params[:kubun],:pt=>"hh"}))
          page.replace_html("workoff", render(:partial => 'ii'))          
          
        end
       
      when "workoff"
        render :update do |page|
          page.replace_html(params[:kubun], render(:partial => 'setmm', :locals => {:hh => params[:hh],:kb=>params[:kubun],:pt=>"ii"}))
        end
        session[:hh_off]=params[:hh]
      else
    end
      	       	



  end
  
  def show_hhmm
  	x1 = {:dom=>"workon", :par=>"hh"}
  	x2 = {:dom=>"workoff", :par=>"ii"}  	
  	case params[:kubun]
  	  when "workon"
  	    session[:mm_on]=params[:mm]
        render :update do |page|
          page.replace_html("workon", render(:partial => 'showhhmm', :locals => {:hh => params[:hh],:mm => params[:mm],:kubun=>x1}))

        end 
  	  when "workoff"
  	    session[:mm_off]=params[:mm]
        render :update do |page|
          page.replace_html("workoff", render(:partial => 'showhhmm', :locals => {:hh => params[:hh],:mm => params[:mm],:kubun=>x2}))
        end   	  	
  	  else
  	end  			

  end
  
# 試験的なコントローラー
  def test
  	@hon=params[:hour_on].to_i
  	redirect_to :action => "new"
# 	render :update do |page|
#     page.replace_html (:abcd, params[:hour_on])
#     page.replace_html (:work_off, render(:partial => 'taishutu', :locals=>{:xx => @hon}))
#   end 
  end	
  	
  	
#■new_staff_rec
# ｽﾀｯﾌの記録を作成（attend/show中）
  def new_staff_rec
    @staff_rec = StaffRec.new
# @staff_rec.attend_id = session[:attend].id
    @staff_rec.attend_id = session[:att_id]
    @attend = Attend.find(session[:att_id])
    sh = @attend.time_start.strftime('%H')
    eh = @attend.time_end.strftime('%H')
    dh = (@attend.time_end - @attend.time_start)/3600
    rh = %w{00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23}
    @hhh= rh[rh.index(sh), dh+1]
    @h  = (@attend.time_start.strftime('%H')..@attend.time_end.strftime('%H'))
 #  @hhh = @h.to_a
  end

#■create_staff_rec
  def create_staff_rec
    @staff_rec = StaffRec.new(params[:staff_rec])
    #非ﾌｫｰﾑ入力の時間（hours/minutes）とattendの日付からstaff_recのdatetimeを得る
    @staff_rec.save
    flash[:notice] = "指導員記録は正常に登録されました"
    @staff_rec = StaffRec.new
    @staff_rec.attend_id = params[:attnd]
    @staff_recs= Attend.find(params[:attnd]).staff_recs
  end

#■sel_grp_recs
# グループ記録の選択表示切替  
  def sel_grp_recs
    session[:grp] = params[:grp] if params[:grp]
    @attend = Attend.find(params[:id])
 #本日の日付のグループ記録
    case session[:grp]
    when 'all'
      @grp_recs_today = GroupRec.of_attend_date(@attend)
    when 'on'
      @grp_recs_today = GroupRec.of_attend_date(@attend).of_attend_grp(@attend)
      #xの内そのgroup_idが[:grp_ids]に含まれるもの
    else
      @grp_recs_today = GroupRec.of_attend_date(@attend)
    end
  end

#■INDEX
# GET /attends
# GET /attends.xml
  def index
# if current_user is a staff then show only his/her own records
    if current_user.staff
      @attends = Attend.find(
        :all,
#        :conditions => ['staff_id=?', current_user.staff.id],
        :order => "time_start DESC"
      ) 
    else
      @attends = Attend.find(
        :all, :order => "time_start DESC"
      ) 
    end
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it


    set_period_session
    @attends = Attend.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] ).of_attend(current_user.staff.id)
=end      
      
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ

    session[:ext] = @attends.map{|i| i.id}      
=end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attends }
    end
  end
  
=begin ■　リストに記入する値を児童毎記録毎に求める（共通化8.3）
古いアクションを念のため残す
#■boy_shidou_recs
# 当該日付当該児童の複数指導記録を求めなければ'-'を返す
  def boy_shidou_recs(boy)
    if boy.shidou_recs.blank?
      k = '-'
    else
      k = boy.shidou_recs.select{ |j| j.date == @attend.time_start.to_date } 
    end
    if k.blank?
      k = '-'
    else
      k
    end
  end
=end
  def recs_of_attend(boy, x)
  	x="#{x}_recs"
    if eval("boy.#{x}.blank?")
      k = '-'
    else
      k = eval("boy.#{x}.select{ |j| j.date == @attend.time_start.to_date }")
    end
    if k.blank?
      k = '-'
    else
      k
    end
  end









#■show
# GET /attends/1
# GET /attends/1.xml
  def show  
  	@attend = Attend.find(params[:id])
  	b=Boy.all.map{|k|k.id}
  	
  	session[:three_days] 
  	
  	if params[:knd]
  		set_period_session
  		get_session_ext_of_attend(session[:days_to_show].to_i,b, @attend)
  	end	
    if params[:days_to_show]
  		set_period_session
  		get_session_ext_of_attend(params[:days_to_show].to_i,b, @attend)
  		session[:days_to_show] = params[:days_to_show]
  	end	

get_session_ext_of_attend(session[:days_to_show].to_i,b, @attend)



=begin rdoc ■出勤記録の抽出範囲
現在のユーザーがスタッフであればスタッフの出勤記録だけ、スタッフでなければ全ての出勤記録
要変更スーパーユーザーは全ての出勤記録を見れる
=end
    if current_user.staff
      @attends = Attend.find(
        :all, :conditions => ['staff_id=?', current_user.staff.id],
        :order => "time_start DESC"
      ) 
    else
      @attends = Attend.find(
        :all,
        :order => "time_start DESC"
      ) 
    end
=begin rdoc ■params[:attn_id]によりセッションを設定
現在のユーザーがスタッフであればスタッフの出勤記録だけ、スタッフでなければ全ての出勤記録
要変更スーパーユーザーは全ての出勤記録を見れる
=end
    if params[:attn_id]
      @attend = Attend.find(params[:attn_id])
      session[:att_id]=params[:attn_id]
      session[:attend]=@attend
    else  
      @attend = Attend.find(params[:id])
      session[:att_id]=params[:id]
      session[:attend]=@attend
    end
    @icon02 = "/images/maximize.gif"
    @staff_recs= @attend.staff_recs
# @option_for_attend_date
    @option_for_attend_date =  @attends.map{|k| [ k.time_start.to_date, k.id]}
    @option_for_attend_date.insert(0, ["…日付選択…" , ''])
    
    @options_for_days = ['1','2','3','4','5','6','7']
    
# 01)prev/next
#   @next = next_index(@attend)	#配列のひとつ後の要素の位置
#   @prev = prev_index(@attend)	#配列のひとつ前の要素の位置
    @dif= (@attend.time_end - @attend.time_start)/3600 
# 03)各種記録の担当児童日毎該当表
    @boys   = @attend.staff.boys      #このｽﾀｯﾌの担当児童(@boys)
    @boyids = @boys.map{|i| i.id}     #担当児童のidの集合（配列）@boyids
=begin
  このｽﾀｯﾌの担当児童を含むstay_out_recsをもとめる  #その各ﾚｺｰﾄﾞについてmapで要素を
    boy.name/
    case_category/
    dayInRange?（attendの日付がstay_out_recの範囲か？）
  の３要素に変換する
 上記の配列（の配列）をpartialのobjectに指定してpartial（_myjidou）を呼ぶ
=end
    @boysincharge5 = @boys.map {
      |i| [
        i.name,                         #児童名前 jido[0] in _myjido.html.erb
        recs_of_attend(i,"shidou"),     #指導記録 jido[1] in _myjido.html.erb 該当ﾚｺｰﾄﾞ
        recs_of_attend(i,"school"),     #学校記録 jido[2] in _myjido.html.erb
        recs_of_attend(i,"med"),        #医療記録 jido[3] in _myjido.html.erb
        recs_of_attend(i,"stay_out"),   #外泊記録 jido[4] in _myjido.html.erb
        i.groups.map{|k|[k.name]}.to_s, #ｸﾞﾙｰﾌﾟ  # jido[5] in _myjido.html.erb
        i                                       # jido[6] in _myjido.html.erb  
      ]
    }
=begin ■ group_recのsession[:ext]
ext0 is allocated for group\rec
=end
    x=@attend
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
    @group_recs = GroupRec.find(session[:ext0]) 
    @group_recs_cnt = @group_recs.size                                     

# 04)終了
    respond_to do |format|
      format.html # show.html.erb
#     format.js      
      format.xml  { render :xml => @attend }
    end
  end

#■SELECT_ATTENDS
  def select_attends
  end

#■NEW
# GET /attends/new
# GET /attends/new.xml
  def new

   @hon = 11
    @attend = Attend.new
=begin rdoc ■ message handling
get this weeks from to date
２週間前から今日までのメッセージを降順に求めセッションに格納
date Desc, created_at Desc 日付は昇順に作成日は降順に
 created_at Desc について　データベースを再構築（fixture:load）すると同じ時間になってしまう
=end    
    period_s = 2.week.ago.to_date          #集計開始日 2週間前からの伝言
    period_e = Time.zone.now.to_date       #集計終了日
#  
    session[:message] = Message.
      between_dates(period_s, period_e).
      find(:all, :order => "date Desc, created_at Desc") 
=begin ■ スタッフのステータスにより振り分け
# 01 ｽﾀｯﾌでない場合は通さない
現在のログインユーザーに割当てられたスタッフがある場合
# 03　　今日の勤務記録が既に１件存在する（２度目以降ののアクセス）
　　　　＞その出勤記録に移動する
　　今日の勤務記録が２件以上ある場合
　　　　＞？？
# 02　　今日の出勤記録が０件（初めてのアクセス）の場合
　　　　＞新たな出勤記録を作成する
　　
このユーザーに割当てられたスタッフがない場合
　　＞初期画面に戻す
=end
# 01 初期画面に戻す
    if current_user.staff.nil?
      flash[:notice]="あなたは指導員として登録されていません。管理者に連絡してください"
      redirect_to :controller=>'welcome', :action => 'index'
# ｽﾀｯﾌであり勤務記録が存在する場合
    elsif current_user.staff.attends
# 今日の出勤記録を@tesに格納
      @tes = current_user.staff.attends.select{|i| i.time_start.to_date == Time.zone.now.to_date}
# 02 do make new attend entry
      if @tes.blank?                                        #今日の出勤記録がない
        @attend.staff_id = current_user.staff.id            #新たな出勤簿にｽﾀｯﾌIDをｾｯﾄ
        @attend.time_start=Time.zone.now             #新たな出勤簿に出勤時間をｾｯﾄ
      
        if session[:hh] && session[:mm_on]                        
          @h = "#{Date.today} #{session[:hh]}:#{session[:mm_on]}:00"
          @attend.time_start = Time.zone.parse(@h)
        end  
        if session[:hh_off] && session[:mm_off]                        
          @h_off = "#{Date.today} #{session[:hh_off]}:#{session[:mm_off]}:00"
          @attend.time_end = Time.zone.parse(@h_off)
        end       
        
        
                              
# 追加したコード
        @staffs = Staff.find(:all)
# 03     
      elsif @tes.size == 1                                  #今日の出勤記録が1件ある場合
        flash[:notice]="既に出勤しています"
# @tes[0]は今日の出勤記録（attend）
        redirect_to @tes[0]                                 #その出勤記録の表示画面に action:show
      else                                                  #出勤記録が複数ある場合
# more than 2 records so show them
        flash[:notice]="あなたの本日の出勤記録が２件あります。チェックしてください。"
        #redirect_to :action=>'select_attends'
      end
# ｽﾀｯﾌであるが勤務記録がない場合
    else
      flash[:notice]="あなたは指導員でこれまで出勤記録がないです"
    end
  end

#■EDIT
# GET /attends/1/edit
  def edit
    @attend = Attend.find(params[:id])
  end

#■CREATE
# POST /attends
# POST /attends.xml
  def create
  	if params[:man]
  	@attend = Attend.new
  	@attend.staff_id = current_user.staff.id
  	@attend.misc = params[:attend][:misc]
  	  x = "#{Time.zone.now.to_date} #{session[:hh]}:#{session[:mm_on]}:00"
    @attend.time_start = Time.zone.parse(x)
  	  x = "#{Time.zone.now.to_date} #{session[:hh_off]}:#{session[:mm_off]}:00"
    @attend.time_end = Time.zone.parse(x)
  	else
    @attend = Attend.new(params[:attend])
    end
    respond_to do |format|
      if @attend.save
        flash[:notice] = '登録に成功しました（出勤簿）'
        format.html { redirect_to(@attend) }
        format.xml  { render :xml => @attend, :status => :created, :location => @attend }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attend.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /attends/1
# PUT /attends/1.xml
  def update
    @attend = Attend.find(params[:id])
    respond_to do |format|
      if @attend.update_attributes(params[:attend])
        flash[:notice] = 'Attend was successfully updated.'
        format.html { redirect_to(@attend) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attend.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /attends/1
# DELETE /attends/1.xml
  def destroy
    @attend = Attend.find(params[:id])
    @attend.destroy
    respond_to do |format|
      format.html { redirect_to(attends_url) }
      format.xml  { head :ok }
    end
  end

  private
end