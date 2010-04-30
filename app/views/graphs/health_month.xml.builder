xml.chart :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff',  :plotGradientColor=>'', :showLegend=>0, :SYAxisMinValue=>150 do 
  
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
      distance = current_user.runs.on(date).sum(:distance)
      time = current_user.runs.on(date).sum(:minutes)
      if distance == 0
        intensity = 'FF'
      else
        intensity = (((time / distance.to_f) - 8) / 4.0 * 255).round.to_s(16)
      end
      xml.set :value=>distance, :color=>"ff#{intensity}00", :toolText=>"#{distance}mi #{time}min"
    end
  end
  
  xml.dataset :seriesName=>'Weight', :parentYAxis=>'S', :color=>'00ccff', :anchorBgColor=>'00ccff' do
    @period.each do |date|
      weight = current_user.weights.on(date).first
      if weight
        xml.set :value=>weight.weight, :toolText=>"#{weight.weight}lbs @ #{weight.body_fat}% BF"
      else
        xml.set
      end
    end
  end
  
end