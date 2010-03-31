xml.chart :chartLeftMargin=>0, :showBorder=>0, :bgColor=>'ffffff', :showValues=>0, :plotGradientColor=>'', :formatNumberScale=>0, :showLegend=>0 do
  xml.categories do
    @period.each do |date|
      if date.day.modulo(2) == 0
        xml.category :label=>''
      else
        xml.category :label=>date.day
      end
    end
  end
  
  xml.dataSet :seriesName=>'Weight', :color=>'FFCC66' do
    @period.each do |date|
      weight = current_user.weights.on(date).first
      if weight
        xml.set :value=>weight.weight
      else
        xml.set
      end
    end
  end
  
  xml.dataSet :seriesName=>'Body Fact', :color=>'FFFF66' do
    @period.each do |date|
      weight = current_user.weights.on(date).first
      if weight
        xml.set :value=>(weight.body_fat / 100 * weight.weight)
      else
        xml.set
      end
    end
  end
      
end