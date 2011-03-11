class ExtrasController < ApplicationController
  include ExtrasHelper
  require 'rubygems'
  require 'zipruby'

=begin rdoc
■　設定ファイルを読み込みハッシュに収納する
=end
  def manage_mode
    if current_user.login == "administrator"
      session[:manage_mode]="admin"
      session[:dsp]="normal"
      render :update do |page|
        page.replace_html("manage_mode", "管理モード:#{session[:manage_mode]}")
        page.visual_effect :highlight, "manage_mode",  :duration => 0.4
      end
    else
      flash[:notice] = '権限がありません'
      redirect_to :back
    end      
  end
  	
  def index
  	session[:manage_mode]="normal"
    session[:dsp]="none"
  	prf = YAML.load_file(RAILS_ROOT + "/tmp/my_pref/taiju_pref.yml")
    @inst_name = prf['inst_name']
    @inst_email = prf['inst_email']
    @inst_address = prf['inst_address']
    @reg_date = prf['reg_date']
    @weather = prf['weather']
    @shokumei = prf['shokumei']
    @category = prf['category']
    @session_period = prf['session_period']
    @inst_zip = prf['inst_zip']
  end

=begin rdoc
■　メールの発送
=end

  def send_mail(x="auto_mail") #x:name of mail_def
  	eval("UserMailer.deliver_#{x}")
  # UserMailer.deliver_auto_mail
    redirect_to :back 
  end

=begin rdoc
■　フィクスチャーを圧縮する
=end

=begin rdoc
'test/fixtures/*.yml' パスの書き方はこれでOK
http://blog.s21g.com/articles/1006参考
Dir::glob("/home/take/public_html/*.html").each {|f|
  # ここにマッチしたファイルに対して行う処理を記述する
  # この例ではファイル名とファイルのサイズを標準出力へ出力している
  puts "#{f}: #{File::stat(f).size} bytes"}
---
require	"rubygems"
require "zipruby"
arc_path = "foo.zip"
raise "could not find #{arc_path}" if not File.exist?( arc_path )
Zip::Archive.open( arc_path ) {|ar|}
---
test/fixtures/*.ymlの各ファイルを圧縮し同じディレクトリー内にtest/fixtures/test.zipを作成する
古い圧縮ファイルがあれば削除し新規に作成する */
=end
  

  def  extract_ymls_to_zip_return
  	# 01 extract
  	extract_fixture #in helper module
  	# 02 zip
    ymls_to_zip
    sqlite_to_zip
    # 03 and return
    redirect_to :back
  end	



=begin rdoc ■　
ＹＭＬファイルのＤＬ
- test/fixtures/test.zipをクライアントにダウンロードする
- test/fixtures/test.zipが無い場合は？？
=end
  def download_ymls
    #ymls_to_zip
    send_file('#{RAILS_ROOT}/test/fixtures/test.zip')
  end

=begin rdoc
# データベースファイルのD
=end
  def download_db
  # send_file("db/production.sqlite3")
    send_file("#{RAILS_ROOT}/db/production.sqlite3")
  end
  
=begin rdoc
# 設定（Ｐｒｅｆ）ファイルのDL
=end
  def download_pref
  # send_file("tmp/my_pref/taiju_pref.yml")
    send_file("#{RAILS_ROOT}/tmp/my_pref/taiju_pref.yml")    
  end	
	
  def show_text
  end

=begin rdoc
# under coding
=end
  def load_fixture
    flash[:notice] = 'under coding'
  	redirect_to :action => 'index'
  end

end