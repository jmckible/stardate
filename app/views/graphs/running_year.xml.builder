xml.chart :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff',  :plotGradientColor=>'', :showLegend=>0 do 
  
  xml.categories do
    @period.step(7) do |date|
      if date.month != (date - 7).month || date == @period.first
        xml.category :label=>date.strftime('%b %e')
      else
        xml.category :label=>''
      end
    end
  end
  
  xml.dataset :seriesName=>'Milage' do
    @period.step(7) do |date|
      xml.set :value=>current_user.runs.on(date..(date+6)).sum(:distance), :color=>'99dd99'
    end
  end
  
  xml.dataset :seriesName=>'Time', :parentYAxis=>'S', :color=>'DD3333', :anchorBgColor=>'DD3333' do
    @period.step(7) do |date|
      value = current_user.runs.on(date..(date+6)).sum(:minutes)
      if value == 0
        xml.set
      else
        distance = current_user.runs.on(date..(date+6)).sum(:distance)
        xml.set :value=>(value / distance.to_f)
      end
    end
  end
  
end