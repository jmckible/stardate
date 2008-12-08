xml.chart :chartLeftMargin=>0, :showBorder=>0, :bgColor=>'ffffff', :showValues=>0, :numberPrefix=>'$', :plotGradientColor=>'', :formatNumberScale=>0, :showLegend=>0 do
  xml.categories do
    @period.each do |date|
      if date.day.modulo(2) == 0
        xml.category :label=>''
      elsif date.day == 1
        xml.category :label=>date.strftime('%b %e')
      else
        xml.category :label=>date.day
      end
    end
  end
  
  xml.dataSet :seriesName=>'Income', :color=>'00CCFF' do
    sum = 0
    @period.each do |date|
      sum += current_user.sum_income(date)
      xml.set :value=>sum
    end
  end
  
  xml.dataSet :seriesName=>'Expenses', :color=>'FF00CC' do
    sum = 0
    @period.each do |date|
      sum += (current_user.sum_expenses(date) * -1)
      xml.set :value=>sum
    end
  end
      
end