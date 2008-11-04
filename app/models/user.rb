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
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  has_many :items,      :order=>:date, :dependent=>:destroy
  has_many :jobs,       :order=>:name, :dependent=>:destroy
  has_many :notes,      :order=>:date, :dependent=>:destroy
  has_many :recurrings, :order=>:day,  :dependent=>:destroy
  has_many :tasks,      :through=>:jobs 
  
  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################  
  def total_on(date)
    items.sum(:value, :conditions=>{:date=>date}) +
    value_unpaid_tasks_on(date)
  end
  alias :total_during :total_on
  
  def total_past_week(date = Date.today)
    total_on (date - 6)..date
  end
  
  def total_past_month(date = Date.today)
    total_on (Date.new date.year, date.month, 1)..date
  end
  
  def total_past_year(date = Date.today)
    total_on (Date.new date.year, 1, 1)..date
  end
  
  def sum_income(period)
    sum_directional period, '>'
  end
  
  def sum_expenses(period)
    sum_directional period, '<'
  end
  
  def value_unpaid_tasks_on(date)
    tasks.unpaid.on(date).collect{|t| t.job.rate * t.minutes / 60.0 }.sum.round
  end
  alias :value_unpaid_tasks_during :value_unpaid_tasks_on
  
  def chart(period)
    expenses = 0
    income   = 0
    Gchart.line :data   => [period.collect{|day| expenses = expenses + (sum_expenses(day) * -1)},
                            period.collect{|day| income = income + sum_income(day)} ],
                :legend => ['Expenses', 'Income'],
                :size   => '800x300',
                :bg     => {:color => 'efefef', :type => 'stripes'},
                :line_colors => 'CC6600,0066CC'
               
  end
  
  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_accessor    :password
  attr_accessible  :email, :password, :password_confirmation, :time_zone
  
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
      items.sum(:value, :conditions=>["date >= ? and date <= ? and value #{operator} 0", period.first, period.last]) || 0
    else
      items.sum(:value, :conditions=>["date = ? and value #{operator} 0", period]) || 0
    end
  end

end
