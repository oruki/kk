=begin rdoc
* このｺﾝﾄﾛｰﾗｰを利用するﾋﾞｭｰ：部分ﾃﾝﾌﾟﾚｰﾄ（_shidou;_school_recs;_med_recs;_stay_out_recs）から参照される
* 用途：対象児童／指導員のみを含むｵﾌﾞｼﾞｪｸﾄ（ﾚｺｰﾄﾞ）を抽出する
* rout:各ｱｸｼｮﾝに対するﾋﾞｭｰは.rjsﾌｧｲﾙでreplace_htmlを実行する（AJAX）
=end
class SelectsController < ApplicationController
# include SelectsHelper
# authentification 2008.06.10
  before_filter :login_required

=begin ■SEL
# * attend および day_rec, case_rec/id から参照される
# * ﾋﾞｭｰから検索条件としてknd jido yy mm / 呼び出しﾋﾞｭｰ　対象児童　年　月　が送られる
# * shidou_recでﾃﾞｰﾀ件数が1000程度で処理が非常に重い
# shared/_selector gives params[:knd/:jido/:month] each of which updates new sessions [:kk/:jj/:mm]
# recs to display is stored in session[:kk] sel.rjs should render it
=end
  def sel
    session[:kk] = params[:knd]   if params[:knd]
    session[:jj] = params[:jido]  if params[:jido]
    session[:mm] = params[:month] if params[:month]
# params[:year]が設定されていない場合はsession[:yy]を今年に設定する
    if params[:year]
      yy = params[:year]
      session[:yy] = yy
    else
      yy = Date.today.strftime("%Y")
      session[:yy] = yy
    end
#
    model_name = {
      'shidou'=>'ShidouRec', 'school'=>'SchoolRec',
      'med'=>'MedRec', 'stay_out'=>'StayOutRec' 
    }
    rec_object = {
      'shidou'=>'@shidou_recs', 'school'=>'@school_recs',
      'med'=>'@med_recs', 'stay_out'=>'@stay_out_recs'
    }
# {rec_object[params[:knd]]} = #{model_name[params[:knd]]}.selected_year('2008')
# get this week's from to date
    period_s = 1.week.ago.to_date          #集計開始日
    period_e = Time.zone.now.to_date       #集計終了日
  end
 
#■SELECT_ACCOUNTS
# method for extracting specific boy in list
  def select_accounts
    @accounts = Account.find(:all, :order => "hizuke DESC")
    if params[:boy]
      @accounts = Account.find(:all, :conditions=>['boy_id=?',params[:boy]], :order => "hizuke DESC")
    end
  end

#■SELECT_JIDO_IN_JIDO_EDU_RELS
  def select_jido_in_jido_edu_rels
    @jido_edu_rels = JidoEduRel.find(:all)
    if params[:boy]
      @jido_edu_rels = JidoEduRel.find(:all, :conditions=>['boy_id=?',params[:boy]])
    end
    if params[:edu_inst_name]
      @jido_edu_rels = JidoEduRel.find(:all, :conditions=>['edu_inst_id=?',params[:edu_inst_name]])
    end
    if params[:edu_inst_cat]
      @jido_edu_rels = JidoEduRel.find(:all).select {|i| i.edu_inst.cat == params[:edu_inst_cat]} 
    end
  end

=begin ■ HIT for @shidou_recs
# 下記の一連のｱｸｼｮﾝは各記録の中のstaff,boyをクリックして対象指導員、児童を抽出するメソッド
# 期間（）情報を含む複合検索とするか方針が必要
# 生活指導記録部分ﾃﾝﾌﾟﾚｰﾄ（shared/_shidou.html.erb）から呼ぶ
# session[:ext] is set in controller/index
# session[:ext] is set again after this action
# @*_recs can be accessed by finding session
１.あるモデルを指定し児童ＩＤまたはｽﾀｯﾌＩＤを含むレコードを抽出する

  def hit
    @shidou_recs = recs("shidou")
    @shidou_recs_cnt = @shidou_recs.size   
    recs_rjs("shidou_recs")    
  end
=end
=begin ■ KIK for @school_recs
# 学校記録部分ﾃﾝﾌﾟﾚｰﾄ（shared/_school_recs.html.erb）から呼ぶ
# session[:ext] is set in controller/index
# session[:ext] is set again after this action
# @*_recs can be accessed by finding session

  def kick0
    @school_recs = recs("school")
    @school_recs_cnt = @school_recs.size
    recs_rjs("school_recs") 
  end
=end
=begin ■ MED
# 医療記録部分ﾃﾝﾌﾟﾚｰﾄ（shared/_med_recs.html.erb）から呼ぶ

  def med0
    @med_recs = recs("med")
    @med_recs_cnt = @med_recs.size
    recs_rjs("med_recs")   
  end
=end
=begin ■ STAY_OUT
# session[:ext] is set in controller/index
# session[:ext] is set again after this action
# @*_recs can be accessed by finding session

  def stay_out0
    @stay_out_recs = recs("stay_out")
    @stay_out_recs_cnt = @stay_out_recs.size
    recs_rjs("stay_out_recs") 
  end
=end
=begin ■ GROUP_REC
# session[:ext] is set in controller/index
# session[:ext] is set again after this action
# @*_recs can be accessed by finding session
session[:ext]に現在抽出されているデータのＩＤが記録されている場合ヘルパー（selects_helper.rb）
recsアクションで@*recsデータを取得し件数を取得しインラインjsでパーシャルと件数を更新する
=end
 
  def cancelled_group_rec
  # session[:ext] = GroupRec.of_attend_dates(@attend,3).of_attend_grp(@attend)
    @group_recs = recs("group_rec","hizuke")
    @group_recs_cnt = @group_recs.size   
    recs_rjs2("group_recs")    
  end

end