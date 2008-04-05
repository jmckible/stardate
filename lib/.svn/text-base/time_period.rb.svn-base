module TimePeriod
  def self.week_to_date
    (TzTime.now.to_date - 6)..TzTime.now.to_date
  end
  
  def self.this_month
    Date.new(TzTime.now.year, TzTime.now.month, 1)..Date.civil(TzTime.now.year, TzTime.now.month, -1)
  end
  
  def self.month_to_date
    Date.new(TzTime.now.year, TzTime.now.month, 1)..TzTime.now.to_date
  end
end