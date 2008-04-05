xml.chart :showBorder=>0, :bgColor=>'ffffff', :showValues=>0, :numberPrefix=>'$', :plotGradientColor=>'', :formatNumberScale=>0 do
  xml.categories do
    @period.each do |date|
      xml.category :label=>date.day
    end
  end
  
  xml.dataSet :seriesName=>'Income' do
    sum = 0
    @period.each do |date| 
      sum += current_user.sum_income(date)
      xml.set :value=>sum
    end
  end
  
  xml.dataSet :seriesName=>'Expenses' do
    sum = 0
    @period.each do |date|
      sum += (current_user.sum_expenses(date) * -1)
      xml.set :value=>sum
    end
  end
      
end