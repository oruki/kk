=begin rdoc
医療記録コントローラー
=end
class MedRecsController < ApplicationController
  include ApplicationHelper
# added 2008.06.10 added
before_filter :login_required

#■INDEX
# GET /med_recs
# GET /med_recs.xml
  def index
    @med_recs = MedRec.find(:all, :order => "date Desc")
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end    
    set_period_session  
    @med_recs = MedRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )        
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    session[:ext] = @med_recs.map{|i| i.id}
# 2008-08-08 年月により抽出するラジオボタンを追加
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @med_recs }
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
# GET /med_recs/1
# GET /med_recs/1.xml
  def show
    @med_rec = MedRec.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @med_rec }
    end
  end

#■NEW
# GET /med_recs/new
# GET /med_recs/new.xml
  def new
    @med_rec = MedRec.new
# ADDED
    @med_recs = MedRec.find(:all, :order => "date Desc")
    # ログインユーザーがスタッフIDを持っている場合はstaff_idを先にセットする（2008.07.10）
    @med_rec.staff_id = current_user.staff.id if current_user
    @med_rec.date = params[:date] if params[:date] 
    @med_rec.boy_id = params[:boy_id] if params[:boy_id]
# 以上変更    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @med_rec }
    end
  end

#■EDIT
# GET /med_recs/1/edit
  def edit
    @med_rec = MedRec.find(params[:id])
# ADDED
    @med_recs = MedRec.find(:all, :order => "date Desc")
    # only author of the rec can edit otherwise redirected to show
    redirect_to @med_rec if current_user.staff.id != @med_rec.staff_id
  end

#■CREATE
# POST /med_recs
# POST /med_recs.xml
  def create
    @med_rec = MedRec.new(params[:med_rec])
    respond_to do |format|
      if @med_rec.save
        flash[:notice] = '医療記録は正常に登録されました'
        format.html { redirect_to(@med_rec) }
        format.xml  { render :xml => @med_rec, :status => :created, :location => @med_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @med_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /med_recs/1
# PUT /med_recs/1.xml
  def update
    @med_rec = MedRec.find(params[:id])
    respond_to do |format|
      if @med_rec.update_attributes(params[:med_rec])
        flash[:notice] = '医療記録は正常に更新されました'
        format.html { redirect_to(@med_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @med_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /med_recs/1
# DELETE /med_recs/1.xml
  def destroy
    @med_rec = MedRec.find(params[:id])
    @med_rec.destroy
    respond_to do |format|
      format.html { redirect_to(med_recs_url) }
      format.xml  { head :ok }
    end
  end

end