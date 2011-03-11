=begin rdoc
date::2009.06.10
auth:yasui
====指導員勤務モデル
=end

class Attend < ActiveRecord::Base
# validations
  validates_presence_of :staff_id, :message => '←指導員が入力されていません'
  validates_presence_of :time_start, :message => '←開始時が入力されていません'
  validates_presence_of :time_end, :message => '←終了時が入力されていません'
# validates_presence_of :misc, :message => '←備考が入力されていません'  
  validate :check_work_hour
  validate :validates_work_hours
  validate :check_time_start
  
  
  
# 作業中
# validate :date_uniquness
# 2009.09.30 バグあり　未解決　とりあえずコメントアウト



# relations
  belongs_to :staff
# 資料（RQRef p333）により子ﾓﾃﾞﾙの自動削除を実装
  has_many :staff_recs, :dependent => :destroy
# scopes
# staff_id が x であるデータを抽出する
  named_scope :of_staff
    lambda {
      |x| { :conditions => ["staff_id = ?", x ] }
    }
# 今日の日付を持つﾃﾞｰﾀを抽出する
  named_scope :of_today,:conditions => ["date('time_start','localtime') = ?", Date.today ] 
  named_scope :of_date,
    lambda {
      |x| { :conditions => ["date(time_start) = ?", x ] }
    }
  
  named_scope :selected_year,
    lambda {
      |x| { :conditions => ["strftime('%Y',time_start) = ?", x ] }
    }
  named_scope :selected_month,
    lambda {
      |x| { :conditions => ["strftime('%m',time_start) = ?", x ] }
    }
# x=@boyids
  named_scope :selected_boys,
    lambda {
      |x| { :conditions => ["boy_id IN (?)", x ] }
    }   
  named_scope :between_dates,
    lambda {
      |from, to| {:conditions => ['time_start between ? and ?', from, to]}
    }
  named_scope :of_attend, lambda {|x| { :conditions => ["staff_id = ?", x] }}

  private

#■check_time_start
  def check_time_start
    if time_start.strftime('%H').to_i < 5
      errors.add_to_base("出勤時間が早すぎませんか？")
    end
  end
  
#■check_work_hour
  def check_work_hour
    dsec = time_end - time_start
    if dsec > 24*60*60 or dsec < 1*60*60
      errors.add_to_base(
        "時間の入力範囲が正しくありません(#{time_start.strftime('%H:%M')}から#{time_end.strftime('%H:%M')}まで)"
      )
    end
  end

#■validates_work_hour
  def validates_work_hour
    unless 1*60*60..24*60*60 === (time_end - time_start)
      errors.add_to_base(
        "時間の入力範囲が不正です#{time_start.strftime('%H')}から#{time_end.strftime('%H')}まで"
      )
    end
  end 

#■validates_work_hours
  def validates_work_hours
    if time_end <= time_start
      errors.add_to_base("終了時間が正しくありません")
    end      
  end

# 作業中
=begin
#■validates_date_uniquness
  def date_uniquness
  	the_date = time_start.to_date
  	cnt = Attend.of_staff(staff_id).of_date(the_date)
  # n=cnt.size
  #	d=cnt.map{|k| k.time_start.to_date}.join('--')
    if cnt > 1
      errors.add_to_base("このスタッフ#{staff_id}は同じ日の入力が既に#{ Attend.of_staff(staff_id).of_date(the_date)}件あります--- 日付#{the_date.to_s}")
    end      
  end
=end  
  
    
end