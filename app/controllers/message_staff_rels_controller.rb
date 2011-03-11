class MessageStaffRelsController < ApplicationController
# GET /message_staff_rels
# GET /message_staff_rels.xml
  def index
    @message_staff_rels = MessageStaffRel.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_staff_rels }
    end
  end

# GET /message_staff_rels/1
# GET /message_staff_rels/1.xml
  def show
    @message_staff_rel = MessageStaffRel.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_staff_rel }
    end
  end

# GET /message_staff_rels/new
# GET /message_staff_rels/new.xml
  def new
    @message_staff_rel = MessageStaffRel.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_staff_rel }
    end
  end

# GET /message_staff_rels/1/edit
  def edit
    @message_staff_rel = MessageStaffRel.find(params[:id])
  end

# POST /message_staff_rels
# POST /message_staff_rels.xml
  def create
    @message_staff_rel = MessageStaffRel.new(params[:message_staff_rel])

    respond_to do |format|
      if @message_staff_rel.save
        flash[:notice] = 'MessageStaffRel was successfully created.'
        format.html { redirect_to(@message_staff_rel) }
        format.xml  {
          render :xml => @message_staff_rel, :status => :created, :location => @message_staff_rel 
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_staff_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /message_staff_rels/1
# PUT /message_staff_rels/1.xml
  def update
    @message_staff_rel = MessageStaffRel.find(params[:id])
    respond_to do |format|
      if @message_staff_rel.update_attributes(params[:message_staff_rel])
        flash[:notice] = 'MessageStaffRel was successfully updated.'
        format.html { redirect_to(@message_staff_rel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_staff_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /message_staff_rels/1
# DELETE /message_staff_rels/1.xml
  def destroy
    @message_staff_rel = MessageStaffRel.find(params[:id])
    @message_staff_rel.destroy
    respond_to do |format|
      format.html { redirect_to(message_staff_rels_url) }
      format.xml  { head :ok }
    end
  end
end
