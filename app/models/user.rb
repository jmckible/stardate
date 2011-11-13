class User < ActiveRecord::Base  
  ##########################################
  #       C L A S S   M E T H O D S        #
  ##########################################
  def self.authenticate(email, password)
    return nil if email.blank? or password.blank?
    user = User.find_by_email(email)
    user and (self.encrypt(password, user.password_salt) == user.password_hash) ? user : nil
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt) 
  end
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  has_many :bikes,       :order=>'date',      :dependent=>:destroy
  has_many :ellipticals, :order=>'date',      :dependent=>:destroy
  has_many :items,       :order=>'date',      :dependent=>:destroy
  has_many :jobs,        :order=>'name',      :dependent=>:destroy
  has_many :nikes,       :order=>'date',      :dependent=>:destroy
  has_many :notes,       :order=>'date desc', :dependent=>:destroy
  has_many :recurrings,  :order=>'day',       :dependent=>:destroy
  has_many :runs,        :order=>'date',      :dependent=>:destroy
  has_many :tasks,       :through=>:jobs 
  has_many :vendors,     :through=>:items,    :uniq=>true, :order=>'name'
  has_many :weights,     :order=>'date',      :dependent=>:destroy

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################  
  def total_on(date)
    sum_income(date) + sum_expenses(date)
  end
  alias :total_during :total_on
  
  def total_past_week(date = Date.today)
    total_on (date - 1.week)..date
  end
  
  def total_past_month(date = Date.today)
    total_on (date - 1.month)..date
  end
  
  def total_past_year(date = Date.today)
    total_on (date - 1.year)..date
  end
  
  def sum_income(period)
    sum_directional period, '>'
  end
  
  def sum_expenses(period)
    sum_directional period, '<'
  end
  
  def sum_value(items, period)
    sum = 0
    items.each do |item|
      sum = sum + (days_overlap(item, period) * item.per_diem)
    end
    sum
  end
  
  def value_unpaid_tasks_on(date)
    tasks.unpaid.on(date).collect{|t| t.job.rate * t.minutes / 60.0 }.sum.round
  end
  alias :value_unpaid_tasks_during :value_unpaid_tasks_on
  
  def things_during(period)
    period = period..period unless period.is_a?(Range)
    
    (bikes.during(period) + items.during(period) + notes.during(period) + runs.during(period) + 
     ellipticals.during(period) + nikes.during(period) + weights.during(period)).sort do |x,y|
      if x.date == y.date
        y.created_at <=> x.created_at
      else
        y.date <=> x.date
      end
    end
  end
  
  #####################################################################
  #                       C H A R T   J S O N                         #
  #####################################################################
  def weight_json(period)
    array = []
    step = period.to_a.length > 31 ? 7 : 1
    
    period.step(step) do |date|
      weight_ins = weights.during(date..(date+(step - 1)))
      if weight_ins.empty?
        array << nil
      else
        weight = weight_ins.sum(:weight) / weight_ins.size.to_f
        array <<  weight.to_f
      end
    end 
    array.to_json
  end
  
  def tag_json(period, tag)
    array = []
    period.step(7) do |date|
      all_items = items.during(date..(date+6)).find_tagged_with(tag)
      sum = sum_value all_items, period
      sum = sum * -1 if sum < 0
      array << sum
    end
    array.to_json
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_accessor    :password
  attr_accessible  :email, :password, :password_confirmation, :time_zone, :twitter_username, :twitter_password
  
  validates_confirmation_of :password,                     :if=>:update_password?
  validates_length_of       :password, :within=>4..40,     :if=>:update_password?
  validates_presence_of     :password_confirmation,        :if=>:update_password?
  
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of     :email, :within=>5..100
  validates_uniqueness_of :email
  
  validates_presence_of :time_zone
  
  before_save :encrypt_password
  
  #####################################################################
  #                           P R O T E C T E D                       #
  #####################################################################
  protected
  def update_password?
    new_record? || !password.blank?
  end
  
  def encrypt_password 
    return if password.blank?
    self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp if new_record?
    self.password_hash = self.class.encrypt(password, self.password_salt) 
  end
  
  def sum_directional(period, operator)
    if period.is_a? Range
      sum = 0
      items.where("per_diem #{operator} 0 and ((start between ? and ?) or (finish between ? and ?) or (start <= ? and finish >= ?))", 
        period.first, period.last, period.first, period.last, period.first, period.last).each do |item|
          sum = sum + (days_overlap(item, period) * item.per_diem)
      end
      sum
    else
      items.where("start <= ? and finish >= ? and per_diem #{operator} 0", period, period).sum(:per_diem)
    end
  end
  
  def days_overlap(item, period)
    if item.start <= period.first
      start = period.first
    else
      start = item.start
    end
    
    if item.finish <= period.last
      finish = item.finish
    else
      finish = period.last
    end
    
    return 0 if finish < start
    
    (start..finish).to_a.size
  end

end
