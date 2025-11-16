class AccountGraph

  attr_accessor :account, :period

  def initialize(account, start: nil)
    self.account = account
    if start
      self.period = start.to_date..Time.zone.today
    else
      self.period = account.transactions.order(:date).first.date..account.transactions.order(date: :desc).first.date
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
    dates = @period.step(step).to_a

    # Single query to get all relevant transactions grouped by date
    balance_data = account.household.transactions
      .where('debit_id = ? OR credit_id = ?', account.id, account.id)
      .where(date: ...finish)
      .group('date')
      .select("date,
              SUM(CASE WHEN debit_id = #{account.id} THEN amount ELSE 0 END) as debit_amount,
              SUM(CASE WHEN credit_id = #{account.id} THEN amount ELSE 0 END) as credit_amount")
      .order(:date)

    # Calculate running balance
    running_balance = 0
    balances = {}
    balance_data.each do |bd|
      running_balance += bd.debit_amount - bd.credit_amount
      balances[bd.date] = running_balance
    end

    # Sample at step intervals
    data = []
    dates.each do |date|
      value = balances.select { |d, _| d <= date }.values.last || 0
      value = value * -1 if account.income?
      color = value.negative? ? '#FF00CC' : '#00CCFF'
      data << { y: value, marker: { fillColor: color } }
    end

    data.to_json.html_safe
  end

end
