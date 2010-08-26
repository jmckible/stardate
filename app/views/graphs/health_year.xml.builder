xml.chart :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff',  :plotGradientColor=>'', :showLegend=>0, :SYAxisMinValue=>140 do 
  
  xml.categories do
    @period.step(7) do |date|
      if date.month != (date - 7).month || date == @period.first
        xml.category :label=>date.strftime('%b %e')
      else
        xml.category :label=>''
      end
    end
  end
  
  xml.dataset :seriesName=>'Time' do
    @period.step(7) do |date|
      runs  = current_user.runs.during(date..(date+6))
      bikes = current_user.bikes.during(date..(date+6))
      ellipticals = current_user.ellipticals.during(date..(date+6))
      total = runs.sum(:minutes) + bikes.sum(:minutes) + ellipticals.sum(:minutes)
      xml.set :value=>total, :toolText=>minutes_to_time(total)
    end
  end
  
  xml.dataset :seriesName=>'Weight', :parentYAxis=>'S' do
    @period.step(7) do |date|
      weights = current_user.weights.during(date..(date+6))
      if weights.empty?
        xml.set
      else
        weight   = weights.sum(:weight) / weights.size.to_f
        body_fat = weights.sum(:body_fat) / weights.size.to_f
        xml.set :value=>weight, :toolText=>"#{weight}lbs @ #{body_fat}% BF"
      end
    end
  end

end