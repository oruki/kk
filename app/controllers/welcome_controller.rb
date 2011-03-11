class WelcomeController < ApplicationController
 # この一行を追加
  before_filter :login_required
  skip_before_filter :timecheck
  
  def index
  	session[:manage_mode]="normal"
    #session[:dsp]="none"
    session[:dsp]="normal"
  end
end