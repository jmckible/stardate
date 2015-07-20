xml.chart :numberPrefix=>'$', :rotateLabels=>1, :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff', :plotGradientColor=>'' do 
  
  date = Date.new 2007,1,1
  
  while(date < Time.now.to_date) do
    period = date..date.end_of_month
    
    label = date.month == 1 ? date.strftime('%Y %b') : date.strftime('%b')
    
    transactions = user.transactions.from_vendor(@vendor).during(period)
    sum = user.sum_value transactions, period
    
    sum = sum * -1 if sum < 0
    
    xml.set :label=>label, :value=>sum, :toolText=>"#{date.strftime('%B %Y')}\n$#{sum}, #{transactions.size} transaction", :color=>'00CCFF'
    date = date.next_month
  end

end