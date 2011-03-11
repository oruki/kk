=begin rdoc
date::2008.12.05
auth:yasui
====ケース記録
*　no additional codes added except before_filter
=end
class CaseRecsController < ApplicationController
  include ApplicationHelper	
  before_filter :login_required
#■INDEX
# GET /case_recs
# GET /case_recs.xml
  def index
    @case_recs = CaseRec.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_recs }
    end
  end

#■SHOW
# GET /case_recs/1
# GET /case_recs/1.xml
  def show
    @case_rec = CaseRec.find(params[:id])
    @options_for_boy = CaseRec.all.map{|i| [i.boy.name, i.id]}

# あるboy_idについて複数のｹｰｽ記録が存在する場合があるか？
    if params[:boy_id]
      @case_rec = CaseRec.find( :first, :conditions=> ["boy_id = ?", params[:boy_id]] )
      session[:cur_boy] = params[:boy_id]
    end
    
    @case_rec = CaseRec.find(params[:case_rec_id]) if params[:case_rec_id]
    session[:cur_case_rec] = @case_rec.id

=begin ■　期間のセッション
=end
    set_period_session
  case session[:kk]
    when "shidou"
      @shidou_recs = @case_rec.boy.shidou_recs.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
      @ts=@shidou_recs.size
      session[:ext] = @shidou_recs.map{|i| i.id} if @shidou_recs
    when "school"
      @school_recs = @case_rec.boy.school_recs.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
      session[:ext] = @school_recs.map{|i| i.id} if @school_recs
    when "med"
      @med_recs = @case_rec.boy.med_recs.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
      session[:ext] = @med_recs.map{|i| i.id} if @med_recs
    when "stay_out"
      @stay_out_recs = @case_rec.boy.stay_out_recs.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )
      session[:ext] = @stay_out_recs.map{|i| i.id} if @stay_out_recs
    else 
  end
  
=begin ■　児童選択リストボックス用
aquire only boys who are listed in case_recs and cared by current staff
=end  

=begin
# when boy_id is selected and params is sent back
# あるboy_idについて複数のｹｰｽ記録が存在する場合があるか？
#   @shidou_recs = @case_rec.boy.shidou_recs
=end    

    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_rec }
      format.pdf {
        prawnto :prawn => {
                  :page_layout => :portrait, # 縦
                  :page_size => "A4",
                  :left_margin => 25.mm,
                  :right_margin => 15.mm,
                  :top_margin => 12.mm,
                  :bottom_margin => 15.mm
                },
                :inline => true
        }
    end    
  end

#■NEW
# GET /case_recs/new
# GET /case_recs/new.xml
  def new
    @case_rec = CaseRec.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_rec }
    end
  end

#■EDIT
# GET /case_recs/1/edit
  def edit
    @case_rec = CaseRec.find(params[:id])
  end

#■CREATE
# POST /case_recs
# POST /case_recs.xml
  def create
    @case_rec = CaseRec.new(params[:case_rec])
    respond_to do |format|
      if @case_rec.save
        flash[:notice] = 'CaseRec was successfully created.'
        format.html { redirect_to(@case_rec) }
        format.xml  { render :xml => @case_rec, :status => :created, :location => @case_rec }
      else
        flash[:notice] = 'CaseRec was not successfully created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /case_recs/1
# PUT /case_recs/1.xml
  def update
    @case_rec = CaseRec.find(params[:id])
    respond_to do |format|
      if @case_rec.update_attributes(params[:case_rec])
        flash[:notice] = 'CaseRec was successfully updated.'
        format.html { redirect_to(@case_rec) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_rec.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /case_recs/1
# DELETE /case_recs/1.xml
  def destroy
    @case_rec = CaseRec.find(params[:id])
    @case_rec.destroy
    respond_to do |format|
      format.html { redirect_to(case_recs_url) }
      format.xml  { head :ok }
    end
  end
end