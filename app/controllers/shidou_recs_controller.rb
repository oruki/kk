=begin rdoc
====指導記録コントローラー
* This controller handles the login/logout function of the site.  
=end
class ShidouRecsController < ApplicationController
  include ApplicationHelper
# added 2008.06.10 追加
  before_filter :login_required
=begin ■ヒヤリハット記入欄の表示非表示
=end

  def show_aux_fields
  	x = super_join(params[:shidou_rec][:cat]) if params[:shidou_rec]
  	  @a=Time.zone.now.to_s
  	aux_hiyari = x.index("ヒヤリハット") if x
  	aux_school = x.index("学校") if x
  	aux_med    = x.index("医療") if x
    render :update do |page|
      page.replace_html :here, render(:text => @a+x)
      
      if aux_hiyari
      	page['hiyari_0'].show
      	page['hiyari_1'].show
      else
      	page['hiyari_0'].hide
      	page['hiyari_1'].hide
      end
      
      if aux_school
      	page['school'].show
      else
      	page['school'].hide	
      end
      
      if aux_med
      	page['med'].show
      else
      	page['med'].hide	
      end
      
    end
  end

  def hidehh
  	kk= super_join(params[:shidou_rec][:cat]) if params[:shidou_rec]
  	@a=Time.zone.now.to_s
  	hh = kk.index("学校") if kk
    render :update do |page|
      page.replace_html :here, render(:text => @a+kk)
      page['hiyari'].show if hh
            page['hiyari'].hide unless hh
    end
  end

  def that
  	render(:text=>"kok")
  end

  def it
    aa0=params[:hiyari]
    aa0 ||="hide"	
    render :update do |page|
      #page.replace_html :here, render(:text => "OK")
      eval("page['aux_00a'].#{aa0}")
      eval("page['aux_00b'].#{aa0}")
    end
  end
=begin ■補助項目入力欄の表示非表示
=end
  def update_aux_field
    aa0=params[:g_00]
    aa1=params[:g_01]
    aa2=params[:g_02]
    aa3=params[:g_03]
    aa0 ||="hide"
    aa1 ||="hide"
    aa2 ||="hide"
    aa3 ||="hide"
    session[:aux]=[aa0,aa1,aa2,aa3]
    
    render :update do |page|
      eval("page['aux_00a'].#{aa0}")
      eval("page['aux_00b'].#{aa0}")
      eval("page['aux_01'].#{aa1}")
      eval("page['aux_02'].#{aa2}") 
      eval("page['aux_03'].#{aa3}")
    end
  end
  
=begin rdoc ■ 
====児童指導員関係入力補助
- 児童のグループごとの表示/非表示を更新
=end
  def update_group
    aa0=params[:g_00]
    aa1=params[:g_01]
    aa0 ||="hide"
    aa1 ||="hide"
    render :update do |page|
      eval("page['aux_01'].#{aa0}")
      eval("page['aux_02'].#{aa1}")
    end
# render :layout=>false
  end

=begin rdoc ■INDEX
====INDEX
- フォーマットがPDFの時抽出加工された結果を出力するのでセッション session[:ext]を印刷
# GET /shidou_recs
# GET /shidou_recs.xml
=end
  def index
 unless params[:format]=="pdf"
  # 7/10 次行追加
    @shidou_recs = ShidouRec.find(:all, :order => "date DESC") 
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end
    set_period_session
    @shidou_recs = ShidouRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    session[:ext] = @shidou_recs.map{|i| i.id}    
 end    
#--
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shidou_recs }
      format.pdf {
        prawnto :prawn => {
          :page_layout => :portrait, # 縦
          :page_size => "A4",
          :left_margin => 25.mm,
          #:right_margin => 24,
          #:top_margin => 24,
          :bottom_margin => 15.mm},
        :inline => true
      }
    end
  end

=begin rdoc ■SHOW
# GET /shidou_recs/1
# GET /shidou_recs/1.xml
=end
  def show
    @shidou_rec = ShidouRec.find(params[:id])
    boy=params[:boy]
      if (boy)
        @shidou_recs = ShidouRec.find(:all,:conditions=>['boy_id=?',boy])
      end
    staff=params[:staff]
      if (staff)
       @shidou_recs = ShidouRec.find(:all,:conditions=>['staff_id=?',staff])
      end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shidou_rec }
      format.pdf {
        prawnto :prawn => {
          :page_layout => :portrait, # 縦
          :page_size => "A4",
          :left_margin => 25.mm,
          :right_margin => 15.mm,
          :top_margin => 12.mm,
          :bottom_margin => 15.mm},
        :inline => true
      }
    end
  end

=begin ■ NEW
# GET /shidou_recs/new
# GET /shidou_recs/new.xml
# ログインユーザーがスタッフIDを持っている場合はstaff_idを先にセットする（2008.07.10）
# try表記を採用（2009.4.30）
=end
  def new

    @shidou_rec = ShidouRec.new
    @shidou_rec.staff_id = try(:current_user).staff.id
    @shidou_rec.date = Date.today
    # 以上変更
    # パラメーターにboy_idを持つときは先にセットする。
    @shidou_rec.boy_id = params[:boy_id] if params[:boy_id]
    # パラメーターにdateを持つときは先にセットする。
    @shidou_rec.date = params[:date] if params[:date] 
    @shidou_recs = ShidouRec.find(:all, :order=> "date DESC")
	session[:ext] = @shidou_recs.map{|i| i.id}
	boy = params[:boy]
	if (boy)
		@shidou_recs = ShidouRec.find(:all,:conditions=>['boy_id=?',boy])
	end

	staff = params[:staff]
	if (staff)
    	@shidou_recs = ShidouRec.find(:all,:conditions=>['staff_id=?',staff])
	end
=begin ヒヤリハットのデフォルト値をセット
    @shidou_rec.taisaku = "ヒヤリハットの場合は対策を記入"
=end
    @shidou_rec.taisaku = "ヒヤリハットの場合は対策を記入"
    @shidou_rec.basho = "ヒヤリハットの場合は場所を記入"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shidou_rec }
    end
  end

#■EDIT
# GET /shidou_recs/1/edit
  def edit
    @shidou_rec = ShidouRec.find(params[:id])
  # BELOW LINE ADDED
    @shidou_recs = ShidouRec.find(:all, :order=> "date DESC")
    session[:ext] = @shidou_recs.map{|i| i.id}
    boy=params[:boy]
    if (boy)
      @shidou_recs = ShidouRec.find(:all,:conditions=>['boy_id=?',boy], :order=> "date DESC")
    end
    staff=params[:staff]
    if (staff)
      @shidou_recs = ShidouRec.find(:all,:conditions=>['staff_id=?',staff], :order=> "date DESC")
    end
=begin ■　編集権のコントロール
# only author of the rec can edit otherwise redirected to show
=end
    redirect_to @shidou_rec if current_user.staff.id != @shidou_rec.staff_id
    flash[:notice] = 'あなたの記録ではありません' if current_user.staff.id != @shidou_rec.staff_id
  end

=begin ■CREATE
# POST /shidou_recs
# POST /shidou_recs.xml
=end
  def create	
  	params[:shidou_rec][:cat] = super_join(params[:shidou_rec][:cat])
    @shidou_rec = ShidouRec.new(params[:shidou_rec])
    @shidou_recs = ShidouRec.find(:all, :order=> "date DESC")
    respond_to do |format|
      if @shidou_rec.save
        flash[:notice] = "指導記録は正常に登録されました params hiyari--#{params[:shidou_rec][:cat]}"
        format.html { redirect_to(@shidou_rec) }
        format.xml  { render :xml => @shidou_rec, :status => :created, :location => @shidou_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shidou_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /shidou_recs/1
# PUT /shidou_recs/1.xml
  def update
  	params[:shidou_rec][:cat] = super_join(params[:shidou_rec][:cat])
    @shidou_rec = ShidouRec.find(params[:id])
    @shidou_recs = ShidouRec.find(:all, :order=> "date DESC")
    respond_to do |format|
      if @shidou_rec.update_attributes(params[:shidou_rec])
        flash[:notice] = "指導記録は正常に更新されました#{params[:shidou_rec][:cat]}"
        format.html { redirect_to(@shidou_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shidou_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /shidou_recs/1
# DELETE /shidou_recs/1.xml
  def destroy
    @shidou_rec = ShidouRec.find(params[:id])
    @shidou_rec.destroy

    respond_to do |format|
      format.html { redirect_to(shidou_recs_url) }
      format.xml  { head :ok }
    end
  end
end