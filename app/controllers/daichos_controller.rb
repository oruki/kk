=begin rdoc
date::2006.06.10
auth:yasui
====児童台帳
=end
class DaichosController < ApplicationController
  before_filter :login_required

#■INDEX
# GET /daichos
# GET /daichos.xml
  def index
    @daichos = Daicho.all
    @rec_count=@daichos.size
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @daichos }
    end
  end

#■SHOW
# GET /daichos/1
# GET /daichos/1.xml
  def show
    @daicho = Daicho.find(params[:id])
    @daicho = Daicho.find(params[:daicho_id]) if params[:daicho_id]
    session[:cur_daicho] = @daicho.id    
    
=begin    
    b01 = Daicho.find(:all).map{ |i| i.boy }           		#boys in daichos
    b02 = current_user.staff.boys if current_user.staff		#boys cared by current_user
# 配列の和（両方の配列に含まれる要素のみの配列を作成する）この場合は台帳に存在する児童でかつ現在の指導員が担当する児童
    b03 =  b02 & b01                                   		#union of arrey b01 and b02
# ユーザーが指導員に紐付いておりかつ担当児童を有していないとb02が空配列になり結果としてb03が空配列になる
# 次の　がエラーを発生するためにb03を使用しないでb01（リストに在る児童）でセレクトを構成するように変更（2009.5.27）
#   @options_for_boy = b01.map{|k| [k.name, k.id] }    #used in selection dropdown
=end

    @options_for_boy = Daicho.find(:all).map{ |i| [i.boy.name, i.id] }
        
    @guardians = @daicho.boy.guardians
    @guardian_ids = @guardians.map{|i| i.id}
    @guardians = Guardian.all.select {|i| @guardian_ids.include?(i.id) } 
# あるboy_idについて複数のｹｰｽ記録が存在する場合があるか？
    if params[:boy_id]
      @daicho = Daicho.find( :first, :conditions=> ["boy_id = ?", params[:boy_id]] )
      session[:cur_boy] = params[:boy_id]
    end
    

    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @daicho }
    end
  end

#■NEW
# GET /daichos/new
# GET /daichos/new.xml
  def new
    @daicho = Daicho.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @daicho }
    end
  end

#■EDIT
# GET /daichos/1/edit
  def edit
    @daicho = Daicho.find(params[:id])
  end

#■CREATE
# POST /daichos
# POST /daichos.xml
  def create
    @daicho = Daicho.new(params[:daicho])
    respond_to do |format|
      if @daicho.save
        flash[:notice] = 'Daicho was successfully created.'
        format.html { redirect_to(@daicho) }
        format.xml  { render :xml => @daicho, :status => :created, :location => @daicho }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @daicho.errors, :status => :unprocessable_entity }
      end
    end
  end

#■CREATEUPDATE
# PUT /daichos/1
# PUT /daichos/1.xml
  def update
    @daicho = Daicho.find(params[:id])
    respond_to do |format|
      if @daicho.update_attributes(params[:daicho])
        flash[:notice] = 'Daicho was successfully updated.'
        format.html { redirect_to(@daicho) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @daicho.errors, :status => :unprocessable_entity }
      end
    end
  end

#■CREATEUPDATEDESTROY
# DELETE /daichos/1
# DELETE /daichos/1.xml
  def destroy
    @daicho = Daicho.find(params[:id])
    @daicho.destroy
    respond_to do |format|
      format.html { redirect_to(daichos_url) }
      format.xml  { head :ok }
    end
  end
end