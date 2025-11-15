class AccountGraph

  attr_accessor :account, :period

  def initialize(account, start: nil)
    self.account = account
    if start
      self.period = start.to_date..Date.today
    else
      self.period = account.transactions.order(:date).first.date..account.transaction.order(date: :desc).first.date
    end
  end

  def start
    @period.first
  end

  def finish
    @period.last
  end

  def duration
    finish - start
  end

  def step
    duration < 365 ? 7 : 30
  end

  def x_axis
    @period.step(step).collect{|d| d.strftime('%b %Y')}.to_json.html_safe
  end

  def y_axis
    data = []

    @period.step(step) do |date|
      value = account.balance_on(date)
      value = value * -1 if account.income?
      color = value.negative? ? '#FF00CC' : '#00CCFF'
      data << { y: value, marker: { fillColor: color } }
    end

    data.to_json.html_safe
  end

end
