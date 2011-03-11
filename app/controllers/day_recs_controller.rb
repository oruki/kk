=begin rdoc
date::2009.06.10
auth:yasui
====業務記録
=end
class DayRecsController < ApplicationController
  include ApplicationHelper	
# added 2008.07.31 added
  before_filter :login_required
#■FT
  def ft (x, h, m)
    x.select{ |i| "#{i.hours}:#{i.minutes}" == "#{h}:#{m}" }
  end    

#■INDEX
# GET /day_recs
# GET /day_recs.xml
  def index
    @day_recs = DayRec.find(:all, :order => "hizuke DESC")

=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end
    set_period_session
    @day_recs = DayRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    session[:ext] = @day_recs.map{|i| i.id}    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @day_recs }
      format.pdf {
        prawnto :prawn => {
          :page_layout => :portrait, # 縦
          :page_size => "A4",
          :left_margin => 36,
          :right_margin => 24,
          :top_margin => 24,
          :bottom_margin => 24},
        :inline => true
      }
    end
  end

#■SHOW
# GET /day_recs/1
# GET /day_recs/1.xml
  def show
    @day_rec = DayRec.find(params[:id])
    @day_recs = DayRec.all
# collection of the day
    @staff_recs = StaffRec.
                    find(:all, :order=> "hours").
                    select {|i| i.attend.time_start.to_date == @day_rec.hizuke} 
#　hours and minuts for selection
    h = %w{07 08 09 10 11 12 13 14 15 16 17 18 }
    m = %w{00 15 30 45}
    @s = Array.new(12){[nil,nil,nil,nil]}   #2次元配列の初期化
    12.times do |i|
      4.times do |j|
        @s[i][j] = ft(@staff_recs, h[i], m[j])
      end
    end
# recs of the day
    @group_recs = GroupRec.find(:all, :conditions=>['hizuke=?',@day_rec.hizuke])
    @shidou_recs = ShidouRec.find(:all,:conditions=>['date=?',@day_rec.hizuke])
    @school_recs = SchoolRec.find(:all,:conditions=>['date=?',@day_rec.hizuke])
    @med_recs = MedRec.find(:all,:conditions=>['date=?',@day_rec.hizuke])
    @stay_out_recs = StayOutRec.find(:all,:conditions=>['date=?',@day_rec.hizuke])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @day_rec }
      format.pdf {
        prawnto :prawn => {
                  :page_layout => :portrait, # 縦
                  :page_size => "A4",
                  :left_margin => 36,
                  :right_margin => 24,
                  :top_margin => 24,
                  :bottom_margin => 24
                },
                :inline => true
        }
    end
  end

#■NEW
# GET /day_recs/new
# GET /day_recs/new.xml
  def new
    @day_rec = DayRec.new
# ログインユーザーがスタッフIDを持っている場合はstaff_idを先にセットする（2008.07.10）
# try表記を採用（2009.4.30）
    @day_rec.staff_id = try(:current_user).staff.id
    @day_rec.hizuke = Date.today
# 以上変更
    @day_recs = DayRec.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @day_rec }
    end
  end

#■EDIT
# GET /day_recs/1/edit
  def edit
    @day_rec = DayRec.find(params[:id])
#BELOW ADDED ON 2008.07.11
    @day_recs = DayRec.find(:all, :order => "hizuke DESC")

  end

#■create
# POST /day_recs
# POST /day_recs.xml
  def create
    @day_rec = DayRec.new(params[:day_rec])
    respond_to do |format|
      if @day_rec.save
        flash[:notice] = '登録に成功しました（業務記録）'
        flash[:notice] = '指導記録は正常に登録されました'
      	@day_rec.update_attribute("tenki", params[:day_rec][:tenki].join(','))
        
        
        format.html { redirect_to(@day_rec) }
        format.xml  { render :xml => @day_rec, :status => :created, :location => @day_rec }
      else
        flash[:notice] = 'DayRec was NOT successfully created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @day_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■update
# PUT /day_recs/1
# PUT /day_recs/1.xml
  def update
    @day_rec = DayRec.find(params[:id])
    respond_to do |format|
      if @day_rec.update_attributes(params[:day_rec])
        #■配列を文字列に変換してカテゴリーに入れる
      	@day_rec.update_attribute("tenki", params[:day_rec][:tenki].join(','))
      
        flash[:notice] = '登録に成功しました（業務記録）'
        format.html { redirect_to(@day_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @day_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■delete
# DELETE /day_recs/1
# DELETE /day_recs/1.xml
  def destroy
    @day_rec = DayRec.find(params[:id])
    @day_rec.destroy
    respond_to do |format|
      format.html { redirect_to(day_recs_url) }
      format.xml  { head :ok }
    end
  end
end