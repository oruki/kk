class UsersController < ApplicationController
=begin
# Be sure to include AuthenticationSystem in Application Controller instead
# include AuthenticatedSystem ←2008.06.10 上記の指示によりコメントアウト
# before_filter :login_required
=end
skip_before_filter :timecheck

#■INDEX
# GET /users
# GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

#■SHOW
# GET /users/1
# GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

#■EDIT
# GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

#■UPDATE
# PUT /users/1
# PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @boy.update_attributes(params[:user])
        flash[:notice] = 'Boy was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

#■NEW
# サインアップ画面（2008.05.02/安井）
# render new.rhtml
  def new
  if params[:flag]
      flash[:notice]="申し訳ありません。このサイトでは現在新規ユーザーを作成できません。表示の仮ログイン名でログイン願います"
      redirect_to :back
  end  
  end

#■CREATE
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "ユーザー登録を完了しました"
    else
      render :action => 'new'
    end
  end

#■DESTROY
# DELETE /users/1
# DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end