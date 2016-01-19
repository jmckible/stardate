module Totalling
  def total_on(date)
    sum_income(date) - sum_expenses(date)
  end
  alias total_during total_on

  def total_past_week(date = Time.zone.today)
    total_on((date - 1.week)..date)
  end

  def total_past_month(date = Time.zone.today)
    total_on((date - 1.month)..date)
  end

  def total_past_year(date = Time.zone.today)
    total_on((date - 1.year)..date)
  end

  def sum_income(period)
    transactions.income_credit.on(period).sum(:amount)
  end

  def sum_expenses(period)
    transactions.expense_debit.on(period).sum(:amount)
  end

  def sum_value(items, period)
    sum = 0
    items.each do |item|
      sum = sum + (days_overlap(item, period) * item.per_diem)
    end
    sum
  end

end
