=begin rdoc
date::2009.06.10
auth:yasui
====レポートコントローラー
=end
class ReportsController < ApplicationController
# added 2008.06.10 added
  include ApplicationHelper
  before_filter :login_required
	def show_text
	end	

#■PREF
  def slide_06
  	
  end
  
#■PREF
  def pref
  end

#■SAY_WHEN
  def say_when
    # render :text => "<p>The time is <b>" + DateTime.now.to_s + "</b></p>" 
    render :text => params[:var]
  end

#■START_WHEN
  def start_when
# render :text => "<p>The time is <b>" + DateTime.now.to_s + "</b></p>" 
    render :text => params[:var]
  end

#■END_WHEN
  def end_when
# render :text => "<p>The time is <b>" + DateTime.now.to_s + "</b></p>" 
    render :text => params[:var]
  end  

#■DROPPED_6
  def dropped_6
    render :update do |page|
      page['p16'].hide
    end
  end

#■DROPPED_7
  def dropped_7
    render :update do |page|
      page['p17'].hide
    end
  end

#■DROPPED_8
  def dropped_8
    render :update do |page|
      page['p18'].hide
    end
  end

#■kaigyo
  def kaigyo(str, n)
    st=""
    i = 0
    str.each_char do |x|
      i = i + 1
      if i%n == 0 
        st = st + "#{x}\n"
      else
        st = st + x
      end
    end  
    return st
  end


#■ODD
# 担当児童選択画面（sett）更新ﾎﾞﾀﾝのｱｸｼｮﾝ:DBへの更新作業
  def update_jido_staff_rels
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
  
# 担当児童選択画面（sett）更新ﾎﾞﾀﾝのｱｸｼｮﾝ:DBへの更新作業
  def odd
    sid = current_user.staff.id
    @boys_on = params[:on]
    @boys_off = params[:off]
=begin    
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
=end    
#    redirect_to :action=>'jidou_reg'
  end

#■SETT
# 担当児童選択画面（sett）:前画面（reports > jidou_reg ）の選択結果を確認表示する
  def sett
    @boys_on = Boy.find(:all).select{ |k| params["id_#{k.id}"]} 
    #params[:id_k.id]が存在するものだけ選別
    @boys_off= Boy.find(:all).select{ |k| params["id_#{k.id}"]==nil }
    #params[:id_k.id]が存在しないものだけ選別
  end

#■JIDOU_REG
#担当児童選択画面（jidou_reg）:担当児童をﾁｪｯｸﾎﾞｯｸｽで選択する
  def jidou_reg
    @aa="this is reg"
    @boys = Boy.find(:all)
    @w = 100
    @nn = 12
  end

#■UPDATE-GROUP
#　勤務時間など範囲数値を入力するためのヘルパー
#　参照　DOM 要素のプロパティの変更 (prototype/script.aculo.us element extensions)
#　http://jp.rubyist.net/magazine/?0014-RubyOnRails
  def range
    w = params[:ww]
    render :js => "alert('hello')"
  end

#■RANGECHANGE
  def rangechange
    @w = 200
    render :update do |page|
      page.replace_html :test, '<%= slider(200)%>'
    end
  end

#■UPDATE_GROUP
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

#■UPDATE_GROUP0
  def update_group0
    if params[:g_00]=='show'
      render :update do |page|
        page['00'].show
      end
    else
      render :update do |page|
        page['00'].hide
      end
    end  
    #render :layout=>false
  end
  
  def search_ajax0
    @recipes = Recipe.find( :all,
      :conditions => [ "name LIKE ?",
         "%#{params[:recipe][:name]}%" ] )
    render :layout=>false 
  end

#■INDEX
  def index
    flash[:notice]="申し訳ありません。この機能はまだ実装されていません"
    redirect_to:back
  end

#■KOSEI
  def kosei
=begin    
    #@otoko = @boys.select{|i| i.sex == 1}
    @otoko = Boy.scoped_by_sex(1)
    @otoko05 = @otoko.select {|i| (0..5) === i.birthdate.age}.size
    @otoko611 = @otoko.select {|i| (6..11) === i.birthdate.age}.size
    @otoko1214 = @otoko.select {|i| (12..14) === i.birthdate.age}.size
    @otoko1517 = @otoko.select {|i| (15..17) === i.birthdate.age}.size
    @otoko1825 = @otoko.select {|i| (18..25) === i.birthdate.age}.size

    #@onna = @boys.select{|i| i.sex == 2}
    @onna = Boy.scoped_by_sex(2)  
    @onna05 = @onna.select {|i| (0..5) === i.birthdate.age}.size
    @onna611 = @onna.select {|i| (6..11) === i.birthdate.age}.size
    @onna1214 = @onna.select {|i| (12..14) === i.birthdate.age}.size
    @onna1517 = @onna.select {|i| (15..17) === i.birthdate.age}.size
    @onna1825 = @onna.select {|i| (18..25) === i.birthdate.age}.size
=end    
    @sonota_onna=Boy.scoped_by_status('10').gakurei_range(18,25).onna
    @sonota_otoko=Boy.scoped_by_status('10').gakurei_range(18,25).otoko 
  	      
    @daigaku_otoko = @sonota_otoko.select {|i| i.edu_insts[0].cat == "大学"}.map{|i| i.name}
    @daigaku_igai_otoko = @sonota_otoko.select {|i| i.edu_insts[0].cat != "大学"}.map{|i| i.name}   
    @daigaku_onna  = @sonota_onna.select {|i| i.edu_insts[0].cat == "大学"}.map{|i| i.name}
    @daigaku_igai_onna  = @sonota_onna.select {|i| i.edu_insts[0].cat != "大学"}.map{|i| i.name}

    respond_to do |format|
      format.html { render :action => 'kosei' }
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
  
#■hiyari_hat 
  def hiyari_hat
# フォーマットがPDFの時抽出加工された結果を出力するのでセッション session[:ext]を印刷
    unless params[:format]=="pdf"
	  @hiyari_hats=ShidouRec.all
=begin ■　@*recs
#　recs to display is stored in session[:kk] sel.rjs should render it
=end
      set_period_session
      @hiyari_hats = ShidouRec.between_dates(
        get_period( session[:yy], session[:mm])[0],
        get_period( session[:yy], session[:mm])[1] )
      @hiyari_hats =  @hiyari_hats.select{|i|  i.cat.index("ヒヤリハット") != nil}
=begin ■　多重検索するためのｾｯｼｮﾝｽﾄｱ
=end
      session[:ext] = @hiyari_hats.map{|i| i.id}
    end
    
    respond_to do |format|
      format.html { render :action => 'hiyari_hat' }
      format.pdf {
        prawnto :prawn => {
          :page_layout => :landscape, # 縦
          :page_size => "A5",
          :left_margin => 25.mm,
          :right_margin => 15.mm,
          :top_margin => 12.mm,
          :bottom_margin => 10.mm},
        :inline => true
      }
    end	
  end	


  def slide_07
  	render(:layout => false)
  end



=begin ■ グループ日誌
20090828 グループ日誌はモデルを持たないビューとして扱われる
関連レコードが無い場合はエラーが発生する可能性あり
=end
  def group_diary
  	

      	
# 日付
  	@k=params[:date][:year] if params[:date]
  	@l=params[:date][:month] if params[:date]
  	@m=params[:date][:day] if params[:date]
    @hizuke = "#{@k}-#{@l}-#{@m}".to_date if(@k && @l && @m)
  	@hizuke ||= Date.today.to_date
@hizuke=params[:datepicker].to_date if params[:datepicker]
@hizuke ||= Date.today.to_date



# group_cat
    @cat = params[:group_cat] if params[:group_cat]
    @cat ||= "男児部"
    session[:cur_group_cat]= @cat
    
# group
    @group = Group.find(:first)
 	  @group = Group.find(params[:group_id]) if params[:group_id]
 	  session[:cur_group]= @group

# group_rec
  # @group_recs = GroupRec.of_date(@hizuke).of_group(@group.id)
  	@group_recs = GroupRec.of_date(@hizuke).of_group_cat(@cat)
  	
# staff  	
  	@staffs = @group.boys.map{|i| i.staffs}.flatten.uniq

# グループカテゴリー@catに属するグループに属する児童たち　　　　　　　　
    @boys = Boy.of_group_cat(@cat)

# @boysの担当スタッフを求める
    @staffs = @boys.map{|i| i.staffs}.flatten.uniq
    
# 日付が@hizukeであるshidou_recsを求める
  # @t = @s.map{|i| i.attends}.flatten.select{|j|j.time_start.to_date == @hizuke}.size
    boy_ids = @boys.map{|i|i.id}
    @shidou_recs = ShidouRec.of_date(@hizuke)
    
       
    @kenkou = GroupRec.of_date(@hizuke).of_group_cat(@cat).of_like_cat("健康")
    # only single check marked data
    @koudou = GroupRec.of_date(@hizuke).of_group_cat(@cat).of_cat("行動記録")
       
# 日付が@hizukeであるstaff_recsを求める
    @staff_recs = StaffRec.
                    find(:all, :order=> "hours").
                    select {|i| i.attend.time_start.to_date == @hizuke}.
                    select {|j| @staffs.index(j.attend.staff)}
                    
# グループカテゴリー@catに属するグループに属する児童たちの指導記録のうち日付が@hizukeでカテゴリーに外泊を含む記録を求める
    boy_ids = @boys.map{|i|i.id}
    @gaihaku = ShidouRec.of_date(@hizuke).selected_boys(boy_ids).of_like_cat("外泊")
    @gaihaku_size = @gaihaku.map{|k|k.boy.name}.uniq.size
    @gaihaku_boys = @gaihaku.map{|k|k.boy.name}.uniq.join(', ')
    
   # render(:layout => false)
    
    
  end	
  
  
  
end





















