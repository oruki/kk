=begin rdoc
date::2009.06.10
auth:yasui
====児童教育期間関係コントローラー
=end

class JidoEduRelsController < ApplicationController
# added 2008.06.10 added
 before_filter :login_required

#■INDEX
# GET /jido_edu_rels
# GET /jido_edu_rels.xml
  def index
    @jido_edu_rels = JidoEduRel.find(:all)
    @rec_count=@jido_edu_rels.size
    @shidou_recs = ShidouRec.find(:all)


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jido_edu_rels }
    end
  end

#■SHOW
# GET /jido_edu_rels/1
# GET /jido_edu_rels/1.xml
  def show
    @jido_edu_rel = JidoEduRel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jido_edu_rel }
    end
  end

#■NEW
# GET /jido_edu_rels/new
# GET /jido_edu_rels/new.xml
  def new
    @jido_edu_rel = JidoEduRel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jido_edu_rel }
    end
  end

#■EDIT
# GET /jido_edu_rels/1/edit
  def edit
    @jido_edu_rel = JidoEduRel.find(params[:id])
  end

#■CREATE
# POST /jido_edu_rels
# POST /jido_edu_rels.xml
  def create
    @jido_edu_rel = JidoEduRel.new(params[:jido_edu_rel])

    respond_to do |format|
      if @jido_edu_rel.save
        flash[:notice] = 'JidoEduRel was successfully created.'
        format.html { redirect_to(@jido_edu_rel) }
        format.xml  { render :xml => @jido_edu_rel, :status => :created, :location => @jido_edu_rel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jido_edu_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /jido_edu_rels/1
# PUT /jido_edu_rels/1.xml
  def update
    @jido_edu_rel = JidoEduRel.find(params[:id])

    respond_to do |format|
      if @jido_edu_rel.update_attributes(params[:jido_edu_rel])
        flash[:notice] = 'JidoEduRel was successfully updated.'
        format.html { redirect_to(@jido_edu_rel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jido_edu_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /jido_edu_rels/1
# DELETE /jido_edu_rels/1.xml
  def destroy
    @jido_edu_rel = JidoEduRel.find(params[:id])
    @jido_edu_rel.destroy

    respond_to do |format|
      format.html { redirect_to(jido_edu_rels_url) }
      format.xml  { head :ok }
    end
  end
end