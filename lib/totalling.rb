module Totalling
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
    #sum_directional period, '>'
    transactions.income_credit.on(period).sum(:amount)
  end
  
  def sum_expenses(period)
    #sum_directional period, '<'
    transactions.expense_debit.on(period).sum(:amount)
  end
  
  def sum_value(items, period)
    sum = 0
    items.each do |item|
      sum = sum + (days_overlap(item, period) * item.per_diem)
    end
    sum
  end
  
  def sum_directional(period, operator)
     if period.is_a? Range
       sum = 0
       items.where("per_diem #{operator} 0 and ((start between ? and ?) or (finish between ? and ?) or (start <= ? and finish >= ?))", 
         period.first, period.last, period.first, period.last, period.first, period.last).each do |item|
           sum = sum + (days_overlap(item, period) * item.per_diem)
       end
       sum.round
     else
       items.where("start <= ? and finish >= ? and per_diem #{operator} 0", period, period).sum(:per_diem).round
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