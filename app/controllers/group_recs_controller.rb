=begin rdoc
date::2009.06.10
auth:yasui
====グループ記録
=end
class GroupRecsController < ApplicationController
  include ApplicationHelper	
  include GroupRecsHelper
# added 2008.07.31 added
before_filter :login_required
=begin ■index
# GET /group_recs
# GET /group_recs.xml
=end
  def index
    @group_recs = GroupRec.find(:all, :order => "hizuke DESC")
=begin ■　group_recs
期間をセッションにセットする
期間でレコード抽出
多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    set_period_session
    @group_recs = GroupRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
    session[:ext0] = @group_recs.map{|i| i.id}    
=begin ■　グループ処理
=end
    @groups=Group.find(:all).map{|g| [g.name, g.cat, g.id]}
    @group_recs = grp_recs #helper #if params[:grp] is set

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @group_recs }
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

#■show
# GET /group_recs/1
# GET /group_recs/1.xml
  def show
    @group_rec = GroupRec.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group_rec }
    end
  end
  
#■new
# GET /group_recs/new
# GET /group_recs/new.xml
  def new
    @group_rec = GroupRec.new
#ADDED BELOW LINE
    @group_rec.hizuke = Date.today
    @group_rec.staff_id = try(:current_user).staff.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group_rec }
    end
  end
  
#■edit
# GET /group_recs/1/edit
  def edit
    @group_rec = GroupRec.find(params[:id])
#ADDED BELOW LINE
    @group_recs = GroupRec.find(:all, :order => "hizuke DESC")
    @gp=Group.find(:all).map{|i| [i.name, i.id] }    # for selection box used in new view
  end
  
#■create
# POST /group_recs
# POST /group_recs.xml
  def create
  	params[:group_rec][:cat] = super_join(params[:group_rec][:cat])  	
    @group_rec = GroupRec.new(params[:group_rec])
    respond_to do |format|
      if @group_rec.save
        flash[:notice] = 'ｸﾞﾙｰﾌﾟ記録は正常に登録されました'
        format.html { redirect_to(@group_rec) }
        format.xml  { render :xml => @group_rec, :status => :created, :location => @group_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■update
# PUT /group_recs/1
# PUT /group_recs/1.xml
  def update
  	params[:group_rec][:cat] = super_join(params[:group_rec][:cat])   	
    @group_rec = GroupRec.find(params[:id])
    respond_to do |format|
      if @group_rec.update_attributes(params[:group_rec])
        flash[:notice] = 'ｸﾞﾙｰﾌﾟ記録は正常に更新されました'
        format.html { redirect_to(@group_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■destroy
# DELETE /group_recs/1
# DELETE /group_recs/1.xml
  def destroy
    @group_rec = GroupRec.find(params[:id])
    @group_rec.destroy
    respond_to do |format|
      format.html { redirect_to(group_recs_url) }
      format.xml  { head :ok }
    end
  end
end