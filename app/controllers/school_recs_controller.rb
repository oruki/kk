class SchoolRecsController < ApplicationController
  include ApplicationHelper
# added 2008.06.10 added
before_filter :login_required
=begin ■INDEX

=end
  # GET /school_recs
  # GET /school_recs.xml
  def index
  unless params[:format]=="pdf"
    @school_recs = SchoolRec.find(:all, :order => "date DESC")
    if params[:boy]
      @school_recs = SchoolRec.find(
        :all,:conditions=>['boy_id=?',params[:boy]], :order => "date DESC")
    end
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end       
    set_period_session
    @school_recs = SchoolRec.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
    session[:ext] = @school_recs.map{|i| i.id}
  end    
#------------------------------------------------------**
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_recs }
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

#-----------------------------------------------------------------------------------------------------------------------------SHOW
  # GET /school_recs/1
  # GET /school_recs/1.xml
  def show
    @school_rec = SchoolRec.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_rec }
    end
  end

#-----------------------------------------------------------------------------------------------------------------------------NEW
  # GET /school_recs/new
  # GET /school_recs/new.xml
  def new
  # ADDED BELOW(2008.07.10)

    @school_rec = SchoolRec.new
    # ログインユーザーがスタッフIDを持っている場合はstaff_idを先にセットする（2008.07.10）
    @school_rec.staff_id = current_user.staff.id if current_user
    @school_rec.date = Date.today
    @school_rec.boy_id = params[:boy_id] if params[:boy_id]
    @school_rec.date = params[:date] if params[:date]    
    # 以上変更

    @school_recs = SchoolRec.find(:all, :order => "date DESC")
    session[:ext] = @school_recs.map{|i| i.id}  # this is needed because you use session[:ext] in school/recs/new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_rec }
    end
  end

#-----------------------------------------------------------------------------------------------------------------------------EDIT
  # GET /school_recs/1/edit
  def edit
    #ADDED BELOW(2008.07.10)
    @school_recs = SchoolRec.find(:all, :order => "date DESC")
    @school_rec = SchoolRec.find(params[:id])
    
    @school_recs = SchoolRec.find(:all, :order => "date DESC")
    session[:ext] = @school_recs.map{|i| i.id}  # this is needed because you use session[:ext] in school/recs/new
    
    @school_rec.boy_id = params[:boy_id] if params[:boy_id]
    # only author of the rec can edit otherwise redirected to show
    redirect_to @school_rec if current_user.staff.id != @school_rec.staff_id
  end

#-----------------------------------------------------------------------------------------------------------------------------CREATE
  # POST /school_recs
  # POST /school_recs.xml
  def create
    @school_rec = SchoolRec.new(params[:school_rec])

    respond_to do |format|
      if @school_rec.save
        flash[:notice] = 'SchoolRec was successfully created.'
        format.html { redirect_to(@school_rec) }
        format.xml  { render :xml => @school_rec, :status => :created, :location => @school_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------------------------------------------------------------------------UPDATE
  # PUT /school_recs/1
  # PUT /school_recs/1.xml
  def update
    @school_rec = SchoolRec.find(params[:id])

    respond_to do |format|
      if @school_rec.update_attributes(params[:school_rec])
        flash[:notice] = 'SchoolRec was successfully updated.'
        format.html { redirect_to(@school_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------------------------------------------------------------------------DESTROY
  # DELETE /school_recs/1
  # DELETE /school_recs/1.xml
  def destroy
    @school_rec = SchoolRec.find(params[:id])
    @school_rec.destroy

    respond_to do |format|
      format.html { redirect_to(school_recs_url) }
      format.xml  { head :ok }
    end
  end
end