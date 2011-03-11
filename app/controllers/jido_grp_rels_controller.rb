=begin rdoc
date::2009.06.10
auth:yasui
====児童ｸﾞﾙｰﾌﾟ関係コントローラー
=end
class JidoGrpRelsController < ApplicationController
# added 2008.06.10 added
  before_filter :login_required

  def sort_grp
    @jgrs = JidoGrpRel.find(:all, :order => "name")
    render :action => "index"
    respond_to do |format|
      format.html # sort_grp.html.erb
      format.xml  { render :xml => @jido_grp_rels }
    end
  end
#■INDEX
  # GET /jido_grp_rels
  # GET /jido_grp_rels.xml
  def index
    @jido_grp_rels = JidoGrpRel.find(
      :all, :include => :boy,
      :order => "boys.sex , boys.birthdate desc")
    if params[:sort]=="grp"
     # @jido_grp_rels = JidoGrpRel.find(:all, :order => :group_id )
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jido_grp_rels }
    end
  end

#■SHOW
  # GET /jido_grp_rels/1
  # GET /jido_grp_rels/1.xml
  def show
    @jido_grp_rel = JidoGrpRel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jido_grp_rel }
    end
  end

#■NEW
  # GET /jido_grp_rels/new
  # GET /jido_grp_rels/new.xml
  def new
    @jido_grp_rel = JidoGrpRel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jido_grp_rel }
    end
  end

#■EDIT
  # GET /jido_grp_rels/1/edit
  def edit
    @jido_grp_rel = JidoGrpRel.find(params[:id])
  end

#■CREATE
  # POST /jido_grp_rels
  # POST /jido_grp_rels.xml
  def create
    @jido_grp_rel = JidoGrpRel.new(params[:jido_grp_rel])

    respond_to do |format|
      if @jido_grp_rel.save
        flash[:notice] = 'JidoGrpRel was successfully created.'
        format.html { redirect_to(@jido_grp_rel) }
        format.xml  { render :xml => @jido_grp_rel, :status => :created, :location => @jido_grp_rel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jido_grp_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
  # PUT /jido_grp_rels/1
  # PUT /jido_grp_rels/1.xml
  def update
    @jido_grp_rel = JidoGrpRel.find(params[:id])

    respond_to do |format|
      if @jido_grp_rel.update_attributes(params[:jido_grp_rel])
        flash[:notice] = 'JidoGrpRel was successfully updated.'
        format.html { redirect_to(@jido_grp_rel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jido_grp_rel.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DELETE
  # DELETE /jido_grp_rels/1
  # DELETE /jido_grp_rels/1.xml
  def destroy
    @jido_grp_rel = JidoGrpRel.find(params[:id])
    @jido_grp_rel.destroy

    respond_to do |format|
      format.html { redirect_to(jido_grp_rels_url) }
      format.xml  { head :ok }
    end
  end

#■ODD
# * 児童グループ関係入力用
# * 担当児童選択画面（sett）更新ﾎﾞﾀﾝのｱｸｼｮﾝ:DBへの更新作業
  def odd
    sid = current_user.staff.id
    @boys_on = params[:on]
    @boys_off = params[:off]
# ﾁｪｯｸされている児童について現在担当児童でなければ追加登録する
    for k in @boys_on
      if Rel.of_staff(sid).of_boy(k).blank?
        rel = Rel.new
        rel.staff_id = sid
        rel.boy_id  = k
        rel.save
      end
    end
# ﾁｪｯｸされていない児童について現在担当児童なら関係を削除する  
    for k in @boys_off
      if Rel.of_staff(sid).of_boy(k)
        rel = Rel.of_staff(sid).of_boy(k)
        for kk in rel
          kk.destroy
        end  
      end
    end
    redirect_to :action=>'jidou_reg'
  end

#■SETT
#担当児童選択画面（sett）:前画面（reports > jidou_reg ）の選択結果を確認表示する
  def sett
    @boys_on = Boy.find(:all).select{ |k| params["id_#{k.id}"]}   #params[:id_k.id]が存在するものだけ選別
    @boys_off= Boy.find(:all).select{ |k| params["id_#{k.id}"]==nil }   #params[:id_k.id]が存在しないものだけ選別
  end

#■JIDOU_REG
#担当児童選択画面（jidou_reg）:担当児童をﾁｪｯｸﾎﾞｯｸｽで選択する

  def update_group
    aa0=params[:g_00]
    aa1=params[:g_01]
    aa2=params[:g_02]
    aa3=params[:g_03]
    aa0 ||="hide"
    aa1 ||="hide"
    aa2 ||="hide"
    aa3 ||="hide"
    render :update do |page|
      eval("page['00'].#{aa0}")
      eval("page['01'].#{aa1}")
      eval("page['02'].#{aa2}")
      eval("page['03'].#{aa3}")
    end
# render :layout=>false
  end

end