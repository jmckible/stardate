class User < ApplicationRecord
  include Totalling

  # ------------------------------------------------------------------------- #
  #                      C L A S S   M E T H O D S                            #
  # ------------------------------------------------------------------------- #
  def self.authenticate(email, password)
    return nil if email.blank? or password.blank?
    user = User.find_by email: email
    self.encrypt(password, user&.password_salt) == user&.password_hash ? user : nil
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  # ------------------------------------------------------------------------- #
  #                          R E L A T I O N S H I P S                        #
  # ------------------------------------------------------------------------- #
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

  # ------------------------------------------------------------------------- #
  #                          O B J E C T    M E T H O D S                     #
  # ------------------------------------------------------------------------- #
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

  # ------------------------------------------------------------------------- #
  #                             C H A R T   J S O N                           #
  # ------------------------------------------------------------------------- #
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

  # ------------------------------------------------------------------------- #
  #                           V A L I D A T I O N S                           #
  # ------------------------------------------------------------------------- #
  has_secure_password

  validates :email, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true
  validates :name, presence: true
  validates :time_zone, inclusion: ActiveSupport::TimeZone.all.map(&:name)
end
