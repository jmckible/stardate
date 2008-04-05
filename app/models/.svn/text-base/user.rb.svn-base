require 'digest/sha1'
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
  
  ##########################################
  #       O B J E C T   M E T H O D S      #
  ##########################################
  has_many :items,      :order=>:date, :dependent=>:destroy
  has_many :jobs,       :order=>:name, :dependent=>:destroy
  has_many :recurrings, :order=>:day,  :dependent=>:destroy
  has_many :tasks,      :through=>:jobs 
  
  attr_accessor  :password
  attr_protected :password_hash
  attr_protected :password_salt
  attr_protected :created_at
  
  composed_of :tz, :class_name=>'TimeZone', :mapping=>[:time_zone, :time_zone]
  
  before_save :encrypt_password
  
  validates_confirmation_of :password,                     :if=>:update_password?
  validates_length_of       :password, :within=>4..40,     :if=>:update_password?
  validates_presence_of     :password_confirmation,        :if=>:update_password?
  
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of     :email, :within=>5..100
  validates_uniqueness_of :email
  
  validates_presence_of :time_zone
  
  ##########################################
  #             T O T A L I N G            #
  ##########################################
  def total_on(date)
    total = (items.sum :value, :conditions=>{:date=>date}) || 0
    total += value_unpaid_tasks_on(date)
  end
  alias :total_during :total_on
  
  def total_this_week(date = Date.today)
    total = (items.sum :value, :conditions=>{:date=>((date - 6)..date)}) || 0
    total += value_unpaid_tasks_on((date - 6)..date)
  end
  def total_this_month(date = Date.today)
    start = Date.new(date.year, date.month, 1)
    total = (items.sum :value, :conditions=>{:date=>start..date}) || 0
    total += value_unpaid_tasks_on(start..date)
  end
  def total_this_year(date = Date.today)
    start = Date.new(date.year, 1, 1)
    total = (items.sum :value, :conditions=>{:date=>start..date}) || 0
    total += value_unpaid_tasks_on(start..date)
  end
  
  def activity_during?(date)
    date = date.last..date.first if date.is_a?(Range) && date.last < date.first
    return true if items.count(:conditions=>{:date=>date}) > 0
    return true if tasks.count(:conditions=>{:date=>date}) > 0
    false
  end
  
  ##########################################
  #     I N C O M E  /  E X P E N S E S    #
  ##########################################
  def sum_income(period)
    if period.is_a?(Range)
      income = items.sum(:value, :conditions=>["date >= ? and date <= ? and value > 0", period.first, period.last])
    else
      income = items.sum(:value, :conditions=>["date = ? and value > 0", period])
    end
    return income || 0
  end
  
  def sum_expenses(period)
    if period.is_a?(Range)
      expenses = items.sum(:value, :conditions=>["date >= ? and date <= ? and value < 0", period.first, period.last])
    else
      expenses = items.sum(:value, :conditions=>["date = ? and value < 0", period])
    end
    return expenses || 0
  end
  
  ##########################################
  #                T A S K S               #
  ##########################################
  def value_unpaid_tasks_on(date)
    total = 0
    for task in tasks.on(date)
      total += task.job.rate * task.minutes / 60.0
    end
    total.round
  end
  alias :value_unpaid_tasks_during :value_unpaid_tasks_on
  
  ##########################################
  #           P R O T E C T E D            #
  ##########################################
  protected
  def update_password?
    new_record? || !password.blank?
  end
  
  def encrypt_password 
    return if password.blank?
    self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp if new_record?
    self.password_hash = self.class.encrypt(password, self.password_salt) 
  end

end
