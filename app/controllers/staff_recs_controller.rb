class StaffRecsController < ApplicationController
  include ApplicationHelper
#----------------------------------------------------------------------------------------------------------------FT
  def ft (x, h, m)
    x.select{ |i| i.time == Time.mktime(2000,1,1,h,m,0) }
  end  
=begin ■INDEX
  # GET /staff_recs
  # GET /staff_recs.xml
=end
  def index
    @staff_recs = StaffRec.find(:all)
=begin ■　
#　get_period(application_controller)
#　session[:ext]
group_recは日付を属性に有しないため属するattendを介して日付の範囲のレコードを取得する
その日付範囲のattendの複数のstaff_recsを求めそのＩＤの集合をsession[:ext]にセットする
=end
    set_period_session
    @attends = Attend.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
    session[:ext] = @attends.map{|i| i.staff_recs}.flatten.map{|j| j.id}
    @staff_recs = StaffRec.find(session[:ext])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_recs }
    end
  end
=begin ■SHOW
  # GET /staff_recs/1
  # GET /staff_recs/1.xml
=end
  def show
    @staff_rec = StaffRec.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_rec }
    end
  end
#----------------------------------------------------------------------------------------------------------------NEW
  # GET /staff_recs/new
  # GET /staff_recs/new.xml
  def new
    @staff_rec = StaffRec.new


    @options_for_attend = Attend.find(:all).map{|i| [i.staff.name, i.id]}    
    @options_for_attend .insert 0,["選択" , '']

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_rec }
    end
  end
#----------------------------------------------------------------------------------------------------------------EDIT
  # GET /staff_recs/1/edit
  def edit
    @staff_rec = StaffRec.find(params[:id])
  end
#----------------------------------------------------------------------------------------------------------------CREATE
  # POST /staff_recs
  # POST /staff_recs.xml
  def create
    @staff_rec = StaffRec.new(params[:staff_rec])
    
    x = params[:staff_rec][:attend_id]                #get attend_id
    y = Attend.find(x).time_start.to_date             #date of attend for this staff_rec
    z = "#{y} #{params[:hours]}:#{params[:minutes]}"  #converted into time format
    @staff_rec.time = z.to_time
    respond_to do |format|
      if @staff_rec.save
        flash[:notice] = "StaffRec was successfully created. Params is #{z}"
        format.html { redirect_to(@staff_rec) }
        format.xml  { render :xml => @staff_rec, :status => :created, :location => @staff_rec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staff_rec.errors, :status => :unprocessable_entity }
      end
    end
  end
#----------------------------------------------------------------------------------------------------------------UPDATE
  # PUT /staff_recs/1
  # PUT /staff_recs/1.xml
  def update
    @staff_rec = StaffRec.find(params[:id])

    respond_to do |format|
      if @staff_rec.update_attributes(params[:staff_rec])
        flash[:notice] = 'StaffRec was successfully updated.'
        format.html { redirect_to(@staff_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_rec.errors, :status => :unprocessable_entity }
      end
    end
  end
#----------------------------------------------------------------------------------------------------------------DESTROY
  # DELETE /staff_recs/1
  # DELETE /staff_recs/1.xml
  def destroy
    @staff_rec = StaffRec.find(params[:id])
    @staff_rec.destroy

    respond_to do |format|
      format.html { redirect_to(staff_recs_url) }
      format.xml  { head :ok }
    end
  end
end