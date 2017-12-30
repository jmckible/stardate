class User < ApplicationRecord
  include Totalling

  ########################################################################
  #                      C L A S S   M E T H O D S                       #
  ########################################################################
  def self.authenticate(email, password)
    return nil if email.blank? or password.blank?
    user = User.find_by email: email
    self.encrypt(password, user&.password_salt) == user&.password_hash ? user : nil
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  belongs_to :household

  has_many :jobs,        ->{ order('name') },       dependent: :destroy
  has_many :notes,       ->{ order('date DESC') },  dependent: :destroy
  has_many :recurrings,  ->{ order('day') },        dependent: :destroy
  has_many :tags,        ->{ uniq },                  through: :transactions
  has_many :tasks,                                    through: :jobs
  has_many :transactions, ->{ order('date') },      dependent: :destroy
  has_many :vendors,      ->{ order('name').uniq },   through: :transactions
  has_many :weights,      ->{ order('date') },      dependent: :destroy
  has_many :workouts,                               dependent: :destroy

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
  def value_unpaid_tasks_on(date)
    tasks.unpaid.on(date).collect{|t| t.job.rate * t.minutes / 60.0 }.sum.round
  end
  alias value_unpaid_tasks_during value_unpaid_tasks_on

  def things_during(period)
    period = period..period unless period.is_a?(Range)

    (household.transactions.during(period) + notes.during(period) +
     workouts.during(period) + weights.during(period)).sort do |x,y|
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
      all_transactions = household.transactions.during(date..(date+6)).tagged_with(tag)
      sum = sum_value(all_transactions, period).round
      sum = sum * -1 if sum.negative?
      array << sum
    end
    array.to_json
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  attr_accessor :password

  validates_confirmation_of :password,                if: :update_password?
  validates_length_of       :password, within: 4..40, if: :update_password?
  validates_presence_of     :password_confirmation,   if: :update_password?

  validates_format_of     :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  validates_length_of     :email, within: 5..100
  validates_uniqueness_of :email

  validates_presence_of :household_id, :name, :time_zone

  before_save :encrypt_password

  #####################################################################
  #                           P R O T E C T E D                       #
  #####################################################################
  protected
  def update_password?
    new_record? || password.present?
  end

  def encrypt_password
    return if password.blank?
    self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp if new_record?
    self.password_hash = self.class.encrypt(password, self.password_salt)
  end

end
