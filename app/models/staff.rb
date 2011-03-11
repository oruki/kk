=begin rdoc
date::2009.06.10
auth:yasui
====指導員モデル
=end
class Staff < ActiveRecord::Base
# constants
# validation
  validates_presence_of :name, :message => '←名前が入力されていません'
  validates_presence_of :kana_name, :message => '←フリガナが入力されていません'
  validates_presence_of :birth_date, :message => '←生年月日が入力されていません'
  validates_presence_of :sex, :message => '←性別が入力されていません'
# validates_presence_of :user_id, :message => '←ﾕｰｻﾞｰIDを入力してください（管理者にお問合せ願います）'

# relations
# 多対多関連 :dependent => :destroy　により同時削除可能となる
  has_many :rels, :dependent => :destroy
  has_many :boys, :through => :rels
  has_many :message_staff_rels
  has_many :message_staff_rels_messages, :through => :message_staff_rels

# 多対一関連　相手：belongs_to 
  has_many :messages
  has_many :day_recs
  has_many :attends  
  has_many :staff_recs
  has_many :group_recs
  has_many :shidou_recs
  has_many :school_recs
  has_many :med_recs   
  has_many :stay_out_recs
  has_many :shien_keikakus
   
# 一対一関連  
  belongs_to :user

  def uploaded_image=(image)
    if image.respond_to?(:content_type) and
      image.content_type.match(/^image\b/)
      self.imgf =
        File.extname(image.original_filename)[1..-1].downcase
      self.imgd = image.read
    end
  end

end