xml.chart :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff',  :plotGradientColor=>'', :showLegend=>0 do 
  
  xml.categories do
    @period.each do |date|
      if date.mday.modulo(2) == 0
        label = ''
      else
        label = date.day
      end
      xml.category :label=>label
    end
  end
  
  xml.dataset :seriesName=>'Milage' do
    @period.each do |date|
      xml.set :value=>current_user.runs.on(date).sum(:distance), :color=>'99dd99'
    end
  end
  
  xml.dataset :seriesName=>'Time', :parentYAxis=>'S', :color=>'DD3333', :anchorBgColor=>'DD3333' do
    @period.each do |date|
      value = current_user.runs.on(date).sum(:minutes)
      if value == 0
        xml.set
      else
        xml.set :value=>value
      end
    end
  end
  
end