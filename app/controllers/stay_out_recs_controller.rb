class StayOutRecsController < ApplicationController
  include ApplicationHelper	
# added 2008.06.10 added
before_filter :login_required
#■INDEX
  # GET /stay_out_recs
  # GET /stay_out_recs.xml
  def index
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end   	
    set_period_session
    @stay_out_recs = StayOutRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    session[:ext] = @stay_out_recs.map{|i| i.id}
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stay_out_recs }
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
  # GET /stay_out_recs/1
  # GET /stay_out_recs/1.xml
  def show
    @stay_out_rec = StayOutRec.find(params[:id])
#ADDED
    @stay_out_recs = StayOutRec.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stay_out_rec }
    end
  end

#■NEW
  # GET /stay_out_recs/new
  # GET /stay_out_recs/new.xml
  def new
  
    @stay_out_rec = StayOutRec.new("rcv_name" => params[:thestaff],"boy_id" => params[:boy_id])
    # ログインユーザーがスタッフIDを持っている場合はstaff_idを先にセットする（2008.10.13）
    @stay_out_rec.staff_id =current_user.staff.id if current_user
    @stay_out_rec.date = Date.today
    # 以上変更
    
#ADDED we must show recs rows after creating new record so we need this
    @stay_out_recs = StayOutRec.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stay_out_rec }
    end
  end

#■EDIT
  # GET /stay_out_recs/1/edit
  def edit
    @stay_out_rec = StayOutRec.find(params[:id])
  #ADDED
    @stay_out_recs = StayOutRec.find(:all)
    # only author of the rec can edit otherwise redirected to show
    redirect_to @stay_out_rec if current_user.staff.id != @stay_out_rec.staff_id
  end

#■CREATE
  # POST /stay_out_recs
  # POST /stay_out_recs.xml
  def create
    @stay_out_rec = StayOutRec.new(params[:stay_out_rec])
    @stay_out_recs = StayOutRec.find(:all, :order => "date DESC")
    respond_to do |format|
      if @stay_out_rec.save
        flash[:notice] = '外泊・面接記録は正常に登録されました'
        format.html { redirect_to(@stay_out_rec) }
        format.xml  { render :xml => @stay_out_rec, :status => :created, :location => @stay_out_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stay_out_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
  # PUT /stay_out_recs/1
  # PUT /stay_out_recs/1.xml
  def update
    @stay_out_rec = StayOutRec.find(params[:id])

    respond_to do |format|
      if @stay_out_rec.update_attributes(params[:stay_out_rec])
        flash[:notice] = '外泊・面接記録は正常に更新されました'
        format.html {redirect_to(@stay_out_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stay_out_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
  # DELETE /stay_out_recs/1
  # DELETE /stay_out_recs/1.xml
  def destroy
    @stay_out_rec = StayOutRec.find(params[:id])
    @stay_out_rec.destroy

    respond_to do |format|
      format.html { redirect_to(stay_out_recs_url) }
      format.xml  { head :ok }
    end
  end
end