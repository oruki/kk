=begin rdoc
====児童モデル
author::	ikuro.yasui
date::		2009-06-10
=====RDOCについて
* http://jj.taiju.railsplayground.net/doc/app/index.htmlでは更新が反映しない
* シンボリックリンク「doc」を/public_htmlに作成し上記フォルダapp/にリンクを張る
* http://taiju.railsplayground.net/doc/
* 更新後ターミナルから　rake doc:reapp を実行する
=====次の各モデルとリレーションを有する
1. 多対多関係モデル:　
   * 次の４モデル：　rels jido_grp_rels　jido_guardian_rels　jido_edu_rels
2. 一対多関係モデル:　これらは児童を１だけ持つ
   * 次の７モデル：　accounts shidou_recs med_recs stay_out_recs daichos　shien_keikakus　care_recs
=end

class Boy < ActiveRecord::Base
# validations
  validates_presence_of :name,      :message => '←児童の名前が入力されていません'
  validates_presence_of :kana_name, :message => '←児童のフリガナが入力されていません'
  validates_presence_of :birthdate, :message => '←児童の生年月日が入力されていません'
  validates_presence_of :sex,       :message => '←児童の性別が入力されていません'
#relations
#　多対多関連 :dependent => :destroy　により同時削除可能となる
  has_many :rels, :dependent => :destroy
  has_many :staffs,    :through => :rels  
#  has_many :jido_grp_rels, :dependent => :destroy, :order => 'sex asc'
has_many :jido_grp_rels, :dependent => :destroy
  has_many :groups,   :through => :jido_grp_rels  
  has_many :jido_guardian_rels
  has_many :guardians,  :through => :jido_guardian_rels  
  has_many :jido_edu_rels, :dependent => :destroy
  has_many :edu_insts,  :through => :jido_edu_rels    

# 一対多関連　相手：belongs_to  
  has_many :accounts
  has_many :shidou_recs
  has_many :school_recs
  has_many :med_recs
  has_many :stay_out_recs
  has_many :shien_keikakus
  has_many :daichos
  has_many :case_recs
# scopes
=begin default_scope added
any time you retrieve records from that mode
=end
  default_scope :order => 'status DESC, birthdate DESC, sex ASC, name ASC'
# x=@staf

  named_scope :of_group_cat, lambda {
    |x| {
      :conditions => ["id IN (?)", Group.all.select{|i| i.cat == x}.map{|j| j.boys}.flatten.uniq.map{|k| k.id}] 
    }
  }



  named_scope :youji,:conditions => ['birthdate between ? and ?', Date.today.years_ago(6), Date.today]
  named_scope :jidou,:conditions => ['birthdate between ? and ?', Date.today.years_ago(18), Date.today.years_ago(6)]
  named_scope :sonota,:conditions => ['birthdate between ? and ?', Date.today.years_ago(22), Date.today.years_ago(18) ]
  named_scope :age_between, lambda {
    |a,b| {
      :conditions => ["birthdate between ? and ?", Date.today.years_ago(b), Date.today.years_ago(a)]
    }
  }
  named_scope :otoko, :conditions => {:sex => 1}
  named_scope :onna, :conditions =>  {:sex => 2}

  named_scope :selected_boys, lambda {
    |x| {
      :conditions => ["id IN (?)", "#{x.boys.map{|i| [i.id]} }"] 
    }
  }
  
  named_scope :gakurei, lambda{
    |n|{
      :conditions => ["birthdate between ? and ?",
      "#{Date.today.years_ago(n+1).year}-04-02",
      "#{Date.today.years_ago(n).year}-04-01"]
    }
  }

  named_scope :gakurei_range, lambda{
    |x, y|{
      :conditions => ["birthdate between ? and ?",
      "#{Date.today.years_ago(y+1).year}-04-02",
      "#{Date.today.years_ago(x).year}-04-01"]
    }
  }
    
  named_scope :mishugaku,
    :conditions => ["birthdate between ? and ?",
      "#{Date.today.years_ago(6).year}-04-02".to_date,Date.today]
  
# named_scope :group, lambda {
#	|x| { :conditions => ["id IN (?)", "#{x.boys.map{|i| [i.id]} }"] }
#　}        # x=@group
  
# p453 group for select


end


class Boy
  BoyOption = Struct.new(:id, :name)
  class BoyType
  	attr_reader :type_name, :options
  	def initialize(name)
  	  @type_name = name
  	  @options = []
  	end
  	def <<(option)
  	  @options << option
  	end
  	
  end		
  	
  danshi = BoyType.new("男子")
  d = Boy.otoko.map{|i| [i.id, i.name]}
    danshi << BoyOption.new('','--児童を選択--')
  for k in d
    danshi << BoyOption.new(k[0],k[1])
  end
  
  joshi = BoyType.new("女子")
  j = Boy.onna.map{|i| [i.id, i.name]}
  for k in j
    joshi << BoyOption.new(k[0],k[1])
  end
  OPTIONS = [danshi, joshi]
end