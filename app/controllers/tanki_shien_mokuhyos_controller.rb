class TankiShienMokuhyosController < ApplicationController
# added 2008.10.14 added
  before_filter :login_required

#■INDEX
# GET /tanki_shien_mokuhyos
# GET /tanki_shien_mokuhyos.xml
  def index
    if session[:cur_shien_keikaku]
      @tanki_shien_mokuhyos = TankiShienMokuhyo.
        shien_keikaku_id(session[:cur_shien_keikaku])
      @title = ShienKeikaku.
        find(session[:cur_shien_keikaku]).boy.name
    else  
      @tanki_shien_mokuhyos = TankiShienMokuhyo.find(:all)
    end
    
    # ｾﾚｸﾀｰで支援計画票の作成番号を併記する
    # ｾﾚｸﾀｰのｱｲﾃﾑの順番をｿｰﾄする
    @options_for_mokuhyo = ShienKeikaku.
      find(:all,:order => "boy_id, sakutei_bango").
      map{|i| ["#{i.boy.name}（no.#{i.sakutei_bango}）", i.id]}
=begin
    # @options_for_mokuhyo.insert (0, ["…児童を選択…" , ''])
#viewのｾﾚｸﾀｰでﾌﾞﾗﾝｸの設定が出来ないためﾃﾞﾌｫﾙﾄでﾘｽﾄ1番目の"…児童を選択…"が表示されShienKeikakuのIDはnilとなり検索に失敗する
    #そのままｻﾌﾞﾐｯﾄﾎﾞﾀﾝが押されるとname spaceの演算でエラーとなる
    #一度対象支援計画表（その児童名）を選択したらそのまま選択状態を維持したままｶﾃｺﾞﾘｰの切替をできることが必要
    #params[:shien_keikaku_id]はviewのｾﾚｸﾀｰで選択した値（存在する支援計画ｼｰﾄのID）
    #一人の児童が2枚以上の支援計画ｼｰﾄを持っている場合は@options_for_mokuhyoの選択ﾘｽﾄを調整する必要がある？
=end
    @title = '一覧'  
    if params[:shien_keikaku_id] and params[:cat]
        @tanki_shien_mokuhyos = TankiShienMokuhyo.shien_keikaku_id(params[:shien_keikaku_id]).category(params[:cat])
        @title = ShienKeikaku.find(params[:shien_keikaku_id]).boy.name + params[:cat].cat_to_str
        session[:cur_shien_keikaku]=params[:shien_keikaku_id]
    elsif params[:shien_keikaku_id]
        @tanki_shien_mokuhyos = TankiShienMokuhyo.shien_keikaku_id(params[:shien_keikaku_id])
        @title = ShienKeikaku.find(params[:shien_keikaku_id]).boy.name   
        session[:cur_shien_keikaku]=params[:shien_keikaku_id]
    elsif params[:cat]
        @tanki_shien_mokuhyos = TankiShienMokuhyo.cat(params[:cat])
        #@tanki_shien_mokuhyos = TankiShienMokuhyo.find(:all, :conditions =>[ "shien_keikaku_id = ?", params[:shien_keikaku_id]] )
    end
    session[:cur_cat] = params[:cat] if params[:cat]
    @rec_count = @tanki_shien_mokuhyos.size
    #tanki_shien_mokuhyos > index
    #短期支援目標の一覧表示で親（支援計画票：児童名）を切り替えた時セレクター項目が直近に選んだアイテム表示となるためにｾｯｼｮﾝ保存
    
     @my_data = @tanki_shien_mokuhyos.map{
       |i| [
	       i.id, 
	       i.kadai.cr(11), 
	       i.mokuhyo.cr(11), 
	       i.naiyou.cr(11), 
	       i.hyoka.cr(11)
	       ]
       }     
       
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tanki_shien_mokuhyos }
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
# GET /tanki_shien_mokuhyos/1
# GET /tanki_shien_mokuhyos/1.xml
  def show
    @tanki_shien_mokuhyo = TankiShienMokuhyo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tanki_shien_mokuhyo }
    end
  end

#■NEW
# GET /tanki_shien_mokuhyos/new
# GET /tanki_shien_mokuhyos/new.xml
  def new
    @tanki_shien_mokuhyo = TankiShienMokuhyo.new
    @tanki_shien_mokuhyo.cat = session[:cur_cat] if session[:cur_cat]
    @tanki_shien_mokuhyo.shien_keikaku_id = session[:cur_shien_keikaku] if session[:cur_shien_keikaku]
    @tanki_shien_mokuhyo.date = Date.today
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tanki_shien_mokuhyo }
    end
  end

#■EDIT
  # GET /tanki_shien_mokuhyos/1/edit
  def edit
    @tanki_shien_mokuhyo = TankiShienMokuhyo.find(params[:id])
  end

#■CREATE
# POST /tanki_shien_mokuhyos
# POST /tanki_shien_mokuhyos.xml
  def create
    @tanki_shien_mokuhyo = TankiShienMokuhyo.new(params[:tanki_shien_mokuhyo])

    respond_to do |format|
      if @tanki_shien_mokuhyo.save
        flash[:notice] = 'TankiShienMokuhyo was successfully created.'
        format.html { redirect_to(@tanki_shien_mokuhyo) }
        format.xml  { render :xml => @tanki_shien_mokuhyo, :status => :created, :location => @tanki_shien_mokuhyo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tanki_shien_mokuhyo.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /tanki_shien_mokuhyos/1
# PUT /tanki_shien_mokuhyos/1.xml
  def update
    @tanki_shien_mokuhyo = TankiShienMokuhyo.find(params[:id])

    respond_to do |format|
      if @tanki_shien_mokuhyo.update_attributes(params[:tanki_shien_mokuhyo])
        flash[:notice] = 'TankiShienMokuhyo was successfully updated.'
        format.html { redirect_to(@tanki_shien_mokuhyo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tanki_shien_mokuhyo.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /tanki_shien_mokuhyos/1
# DELETE /tanki_shien_mokuhyos/1.xml
  def destroy
    @tanki_shien_mokuhyo = TankiShienMokuhyo.find(params[:id])
    @tanki_shien_mokuhyo.destroy
    respond_to do |format|
      format.html { redirect_to(tanki_shien_mokuhyos_url) }
      format.xml  { head :ok }
    end
  end
  
end