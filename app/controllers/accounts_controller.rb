=begin rdoc
====アカウントコントローラー
date:: 2008.09.16
author:: yasui
* 児童養護施設で児童や児童保護者から預かる金銭や預金通帳を管理するためのコントローラー
* 単式簿記で実装し実際の運用で複式簿記の必要があれば変更する
=end

class AccountsController < ApplicationController
  include ApplicationHelper	
# date::  2008.06.10 added
before_filter :login_required

#■INDEX
# 各記録ﾓｼﾞｭｰﾙで期間を指定した絞込み検索ができる
# GET /accounts
# GET /accounts.xml
  def index
    @accounts = Account.find(:all, :order => "hizuke DESC" )
# recs to display is stored in session[:kk] sel.rjs should render it
  
=begin
    session[:kk] = params[:knd]       
    session[:jj] = params[:jido]  if params[:jido]
    session[:yy] = params[:year]  if params[:year]
    session[:mm] = params[:month] if params[:month]
    if params[:year]      #params[:year]が設定されていない場合はyyを今年に設定する
      yy = params[:year]
    else
      yy = Date.today.strftime("%Y")      
    end

    session[:yy] ||= yy  
# {2008-08-12 年月により抽出するラジオボタンを追加

    mm=params[:month].to_i if params[:month]
    if params[:year] and params[:month]
      @accounts = @accounts.find_all{ |k| k.hizuke.month == mm }
    else
      @accounts = Account.find(:all, :order => "hizuke DESC")
    end
=end
    set_period_session
    @accounts = Account.between_dates(
      get_period( session[:yy], session[:mm])[0],
      get_period( session[:yy], session[:mm])[1] )



   @image = "/images/rails.png"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

#■SHOW
# GET /accounts/1
# GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

#■NEW
# GET /accounts/new
# GET /accounts/new.xml
  def new
    @account = Account.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

#■EDIT
# GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

#■create
# POST /accounts
# POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(@account) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

#■update
# PUT /accounts/1
# PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

#■destroy
# DELETE /accounts/1
# DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end