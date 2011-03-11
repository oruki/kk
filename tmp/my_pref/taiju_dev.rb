=begin　■開発メモ

link_to "http://taiju.railsplayground.net/jjaux" :url=>"http://taiju.railsplayground.net/jjaux"

=end
=begin　■退所児童をフラグで区別して表示切替（2009-6-21）
・boyｓテーブルにフラグを追加する
　　db/migrate編集
    create_table :boys do |t|
      t.string  :name
      t.string  :kana_name
      t.date    :birthdate
      t.integer :sex
      t.string  :status #これを追加する　00：退所児童（２桁目オプション）　01：在所児童
      t.timestamps
    end
・rake db:migrate RAILS_ENV=production
・フィクスチャー取り込み
　まずjj/emu.railsplayground.netでフィクスチャー抽出
　上記ファイルの加工
・フィクスチャーファイルを読み込み
　　rake db:fixtures:load RAILS_ENV=production 
・実験を先にjj.taiju.railsplayground.netで行うこと

その他　職員児童振り当て機能でｸﾞﾙｰﾌﾟがなくなっているので破綻している
　ｸﾞﾙｰﾌﾟ復活と児童ｸﾞﾙｰﾌﾟ関係で削除できない件を解決
=end
=begin　■fixture　抽出（書出し）の方法
・プラグインがインストールされていることを確認する　 /vendor/plugins/ar_extractor
　　参照URL：http://github.com/abikounso/ar_extractor/tree/master
  Version 1.3.1 / 2009-06-05
・rake db:fixtures:extract RAILS_ENV=production
・rake db:fixtures:extract RAILS_ENV=production FIXTURES=users,clients
　　FIXTURES= にテーブル名称を列記して取込みたいフィクスチャーを指定することも出来る
=end
■database 再構築の方法
・/db/migrate テーブルの構造　最初に必要
・rake db:migrate >> /db/schema.rb  /db/development.sqlite3
・rake db:migrate RAILS_ENV=production >> /db/schema.rb  /db/production.sqlite3
  RAILS_ENV=production を指定すると　production モードの sqlite3 データベースファイルが生成される
■fixture 取込みの方法
・fixtueの場所は　/test/fixtures/ これらのファイルはプラグイン（ar_extractor）により抽出されたもの
・rake db:fixtures:load RAILS_ENV=production >> production.sqlite3 にフィクスチャーファイルが取り込まれる

■working site updating memo
・jj.emu.railsplayground.net から　db/production.sqlite3  test/fixtures
 の２ファイルをコピー　>> jj/taiju.railsplayground.net/
 test/fixtures は現在のDBから抽出する　ar_extracter は最新バージョンに
・jj.taiju.railsplayground.net/>> emu.railsplayground にコピーして再構築する

=begin Railsの理解シリーズ１｜手作業とgenerator
■Railsで使えるgenerator
・scaffold
・script/generate Model
手作業でモデルやコントローラーを作成し独自のビューを与える作業を通じてRailsが自動化している部分をきちんと把握する必要がある
=end
■fast cgi mode で動かすための条件
　1./public中に.htaccessファイルが必要（ReadMeの中に雛形がある）
　2.アプリケーションを作成する時、rals app_name -Dとして「-D」オプションが必要
　　　-D, --with-dispatchers
　　　　Add CGI/FastCGI/mod_ruby dispatches code to generated application skeleton
■ベーシック認証であるディレクトリーを保護する場合
・パスワード保管位置は/.htpasswds（フォルダー）
■ルーティングについての補足
・/config/routs.rb　において　map.resources :extras　のような記載があると　restful　とみなされ
　　/controller_name/action_nameのルーティングが使えなくなる
　　このため　#map.resources :reports　のようにモデルを持たないすなわちrestfulでなくてもよい場合は
　　コメントアウトしたほうがやさしい
■児童を削除した場合の処置
1.多対多関連の場合　参照Q*123　098
　児童　関連　ｽﾀｯﾌ　のように対称的な関連の場合
　　ある児童を削除した時そのIDを参照しているモデルは関連モデルだけ
　　従って児童を削除した場合は関連モデルも削除すればOK
　　  has_many :rels, :dependent => :destroy
  このように　dependentを付け加えると関連モデルのレコードも同時に削除される
  
sikaku 
支援計画表の新規作成と印刷
・/jj.taiju.railsplayground.net で実験する
　１．前提　データは両データベーステーブルとも空である
　２．新規支援目標でエラー
　　　理由：
■検索方法（fgrep）
fgrep -r --include='*.rb' 'test' ./
fgrep -r 'patern' ./

http://d.hatena.ne.jp/lurker/20070312/1173657802
■0714
児童一覧PDF
　・ラジオボタン複数選択　onchange 多重検索を実現　PDFに反映
管理＞設定
　・設定ファイルの値を読み込み表示するように変更

=begin
require 'rubygems'
require 'zipruby'

zipfile = 'test.zip'  # 圧縮されたファイル名
passwd = 'password'   # パスワード

# 圧縮するファイルたち
# ファイル名を文字列で
files = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]

# filesを圧縮して, test.zipを作成
Zip::Archive.open(zipfile, Zip::CREATE) do |arc|
  files.each{|f| arc.add_file(f) }
end

# パスワードつきのZIPファイルにする
Zip::Archive.encrypt(zipfile, passwd)

=end
2009-08-10
attend の新しい入力スタイルで時刻がずれる問題
　午前中なら問題なく午後に日付のずれ？
　日付を求める時に標準時での日付となっている？
　10：00は01：00　9：00は00：00　その日　7：00は-02：00　前の日の22：00
現在チェックしたかぎり8：00以前の時間でも問題はなし

attendの表示（マイページ）で各記録の絞込みを実行すると件数の更新がgroup_recsの帯びにひょうじされてしまう
DOMのIDを区別する必要がある

バックアップ作成する　8/10　12：30
■関連レコードでソート　
findメソッドの:includeオプションの書き方（eager loading）
http://code.nanigac.com/source/wiki/view/641/50
--
jido_grp_relsコントローラーで関連レコードboyの属性でソートする
    @jido_grp_rels = JidoGrpRel.find(
      :all, :include => :boy,
      :order => "boys.sex , boys.birthdate desc")
      
   
named_scope :login, lambda{|login| login.blank? ? {} : {:include => [:user], :conditions => ["login = ?", login]}}

usersテーブルの使用を明示することで参照されるようになった


named_scope :login, lambda{|login| login.blank? ? {} : {:include => [:user], :conditions => ["users.login = ?", login]}}

遅延ロードされるので、対象テーブルへのアクセスを明示しないとincludeされないっぽい
( ﾟ,_Jﾟ) ほむ   
■20090814
訂正済み
１．児童台帳　show画面でセレクトタグが正常に動くように訂正　アクションで@daichoのセットが正しくない位置であった
２．日付移動矢印ボタンの改良　汎用部品化　title表示とフィールドの引数セット
■20090818
01
メーラー　添付書類にZIP指定でファイルの名称が化ける？
02
ヒヤリハットでPDFのとき未記入らんの処理を追加する 空欄なら「？」を代入して処理
    i[2]||="?"
    i[3]||="?"
    i[4]||="?"
03
ヒヤリハットで新規「+」エラーを処理する   
■20090820
・ActionMailerで添付付きメールを自動配信する場合、モデルクラスに記載する添付ファイルのパスは絶対パスである必要
　　　:body => File.read('/home/taijurai/jjaux/test/fixtures/test.zip'),
　　　:body => File.read(RAILS_ROOT+'/test/fixtures/test.zip'),   
 　※cronを起動するｼｪﾙの位置がわからないから絶対パスが必要
・Cronの設定
　Cpanel > cron
・改行を含む文字列を入力通り表示する
　逆引きﾘﾌｧﾚﾝｽ p.231 simple_format(h @body)
・cron     
   /home/taijurai/jjaux/script/runner -e production  'UserMailer.deliver_auto_mail'    
■20090820b
broncoにおいて
/usr/local/bin/ruby /home/oruki/jj/script/runner -e production 'UserMailer.deliver_auto_mail_to_kjg'

これは動く（/usr/local/bin/ruby　rubyのパスを正確に記入　サーバー毎に変わる？）
/home/oruki/jj/script/runner -e production 'UserMailer.deliver_auto_mail_to_kjg'
このようにrubyのパスを省くと
/usr/bin/env ruby /home/oruki/jj/script/runner -e production 'UserMailer.deliver_auto_mail_to_kjg'
のように「/usr/bin/env ruby」で指定した時と同じ扱いとなり"/usr/bin/env: ruby: No such file or directory"とエラーメッセージが届く
----
taijuにおいては一方
/home/taijurai/jjaux/script/runner -e production  'UserMailer.deliver_auto_mail'    
のようにrubyのパスをかかなくても動いている
----
[oruki@bronco ~]$ whereis ruby
ruby: /usr/local/bin/ruby /usr/local/lib/ruby
？？/usr/local/lib/rubyとすればどうなるか？
/bin/sh: /usr/local/lib/ruby: is a directory　　　ｎｇ！

■20090821
cronタスクで自動バックアップ、メール転送するために、production.sqlite3をzip圧縮しメールに添付する必要
broncoサーバーにて/lib/cron/002.rb作成　コマンドラインでは作動する
メーラークラスでファイル名production.sqlite3.zipを添付するように調整　結果待ち
/lib/cronをtaijuサーバーにコピーする


<% s = Group.find(428456302).boys.map{|i| i.staffs}.flatten.uniq %>
<%= s.map{|k|k.attends}.select{|i| i.date==Date.today} %>
■20090826
曜日の表示
　day_recs attend/show 
グループ記録にカテゴリーを設定しグループ業務日誌に反映させる。ＰＤＡ出力欄に対応する
ＤＢメールバックアップのうち実際に施設メールに転送するメール（1回／日）を設定する
フィードバック対策
お世話になっています。支援計画、支援目標の入力を始めていますが、支援目標の特に“総合”の目標がスムーズにいきません。よろしくお願いします。
■20090829
グループ日誌で職員の出勤状況をリスト化するとき出勤しているはずのアテンドデータが拾われない（前日扱い）
その理由：ローカルタイムとグローバルタイムの時差の関係、アテンドで9：00以降なら問題が起こらない
日付チェックのプロセスでグローバルのままチェックしている？
sqlite3の公式サイトを調べるが原因が特定できないためnamedscopeは試用しないことで回避
■20090830
ケース記録ＰＤＦでセレクトボックス児童切り替えがＰＤＦ内容に反映しない
attendのvalidationで重複データをチェックする
業務記録での日付移動ボタン　または　DatePicker
■20090902
昨日ＫＪＧ最終（実運用前）打合せ
・day_red 指導員の記録でチャートが不都合　データの非表示
・指導記録欄でレコード絞込みが動いていない
・他の画面共通　プラスマイナス　の開く閉じるアイコンを作動するためにprototypeの他にscriptaculousが必要
　　　  google.load("scriptaculous", "1");
・jido_grp_relsでパラメーターが正しく伝わっていないため登録に失敗する
      jido_grp_rel[boy_id]　のところ　jido_grp_rels[boy_id] の間違い
■20090906
ターミナルからコマンドでメールを発信する
これはcronに記述する内容と同じ
　script/runner -e production  'UserMailer.deliver_auto_mail'
/app/models/user_mailer.rb/def auto_mail に次の一行を追加した
   extract_ymls_to_zip(x=true)
これをmodelから参照できるために、下記のようにExtrasHelperをインクルードする
　class UserMailer < ActionMailer::Base
     include ExtrasHelper
extras_helper.rb　でメール関連のクラスをコピー
モデルにコントローラークラスを読み込めるか？
複数のクラスから共用したいメソッドがある時、これらをモジュールに定義して各クラスからインクルードして利用する
メールなどで利用したいファイルダウンロード関係のメソッドをヘルパーモジュールであるExtrasHelperに集める
■20090907
whereis ruby でパスを確認すること：/usr/bin/ruby
■TAIJU用（あて先：ＹＤＲ）
/usr/bin/ruby /home/taijurai/jjaux/script/runner -e production 'UserMailer.deliver_auto_mail'
■BRONCO用（あて先：ＫＪＧ）
/usr/local/bin/ruby /home/oruki/jj/script/runner -e production 'UserMailer.deliver_auto_mail_to_kjg'


/usr/bin/ruby /home/taijurai/jjaux/script/runner -e production 'UserMailer.deliver_auto_mail'
■20090920
attendsで同じ日に２件の出勤記録が出来てしまった場合の処理ルーティーンが書かれていない（エラー）
入力チェックでユニークデータの検証を付加する必要あり
■20090929
1.cron reset autosave for kjg mail done need to change frequency to once a day
2.button to download backups by user /done
3.update current version with group_rec report




