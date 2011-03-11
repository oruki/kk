=begin rdoc
====支援計画コントローラー
date:: 2009-06-10
author:: yasui
* This controller handles the login/logout function of the site.  
=end
class ShienKeikakusController < ApplicationController
# added 2008.06.10 added
  before_filter :login_required
  require "prawn/measurement_extensions"
#■INDEX
  # GET /shien_keikakus
  # GET /shien_keikakus.xml
  def index
    @shien_keikakus = ShienKeikaku.find(:all)
    #支援計画が実際無い場合（０件）でもsessionが作成されてエラーとなる

     unless session[:cur_shien_keikaku]
      session[:cur_shien_keikaku]  = @shien_keikakus[0].id if @shien_keikakus
     end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shien_keikakus }
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
# GET /shien_keikakus/1
# GET /shien_keikakus/1.xml
  def show
    @shien_keikaku = ShienKeikaku.find(params[:id])
    session[:cur_shien_keikaku] = @shien_keikaku.id
    @boy = @shien_keikaku.boy
    @attr ||= 'honnin_ikou'
    @seisakusha = @shien_keikaku.staff.name
    tmp = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
    @shisetsu = tmp['inst_name']
    @code = "ID: #{@shien_keikaku.id}－作成番号：第 #{@shien_keikaku.sakutei_bango} 号"  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shien_keikaku }
      format.js
      format.pdf {
        prawnto :prawn => {
          :page_layout => :landscape, # 横
          :page_size => "A3",
         #:left_margin => 56,
          :left_margin => 30.mm,
          :right_margin => 24,
          :top_margin => 24,
        #　:bottom_margin => 24          
          :bottom_margin => 18.mm},
        :inline => true
      }
    end
  end

#■NEW
  # GET /shien_keikakus/new
  # GET /shien_keikakus/new.xml
  def new
    @shien_keikaku = ShienKeikaku.new
    @shien_keikaku.date=Date.today
    @shien_keikaku.staff_id = current_user.staff.id 
    if params[:boy]
        @shien_keikaku.boy_id = params[:boy]
        @shien_keikaku.sakutei_bango = params[:bango].to_i + 1
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shien_keikaku }
    end
  end

#■EDIT
  # GET /shien_keikakus/1/edit
  def edit
    @shien_keikaku = ShienKeikaku.find(params[:id])
  end

#■PUT_BOX
# GET /shien_keikakus/1/putbox
  def putbox
    @shien_keikaku = ShienKeikaku.find(params[:id])
    @attr = params[:attr]
    respond_to do |format|
      format.html # edit_item.html.erb
      format.xml  { render :xml => @shien_keikaku }
      format.js
    end
  end

#■CREATE
# POST /shien_keikakus
# POST /shien_keikakus.xml
  def create
    @shien_keikaku = ShienKeikaku.new(params[:shien_keikaku])
    respond_to do |format|
      if @shien_keikaku.save
        flash[:notice] = 'ShienKeikaku was successfully created.'
        format.html { redirect_to(@shien_keikaku) }
        format.xml  { render :xml => @shien_keikaku, :status => :created, :location => @shien_keikaku }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shien_keikaku.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /shien_keikakus/1
# PUT /shien_keikakus/1.xml
  def updateAlt
    @shien_keikaku = ShienKeikaku.find(params[:id])
    @attr = params[:attr]
# GETTING THE ATTR VALUE
    @attrval = eval '@shien_keikaku' + '.' + @attr
    respond_to do |format|
      if @shien_keikaku.update_attributes(params[:shien_keikaku]) then
        flash[:notice] = 'ShienKeikaku was successfully updated(2008.07.06).'
        @attrval = eval '@shien_keikaku' + '.' + @attr
        format.html { redirect_to(@shien_keikaku) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shien_keikaku.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /shien_keikakus/1
# PUT /shien_keikakus/1.xml
  def update
    @shien_keikaku = ShienKeikaku.find(params[:id])
# render(:partial => "comm", :object => @shien_keikaku)
    respond_to do |format|
      if @shien_keikaku.update_attributes(params[:shien_keikaku])
        flash[:notice] ='正常に更新されました（支援計画）'
        format.html { redirect_to(@shien_keikaku) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shien_keikaku.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
  # DELETE /shien_keikakus/1
  # DELETE /shien_keikakus/1.xml
  def destroy
    @shien_keikaku = ShienKeikaku.find(params[:id])
    @shien_keikaku.destroy

    respond_to do |format|
      format.html { redirect_to(shien_keikakus_url) }
      format.xml  { head :ok }
    end
  end

end