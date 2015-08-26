xml.chart showValues: '0', showBorder: 0, bgColor: 'ffffff',  plotGradientColor: '', showLegend: 0, SYAxisMinValue: 140 do

  xml.categories do
    @period.each do |date|
      if date.mday.modulo(2) == 0
        label = ''
      else
        label = date.day
      end
      xml.category label: label
    end
  end

  xml.dataset seriesName: 'Time' do
    @period.each do |date|
      time = @user.workouts.on(date).sum(:minutes)
      xml.set value: time, toolText: "#{time}min"
    end
  end

  xml.dataset seriesName: 'Weight', parentYAxis: 'S' do
    @period.each do |date|
      weight = @user.weights.on(date).first
      if weight
        xml.set value: weight.weight, toolText: "#{weight.weight}lbs @ #{weight.body_fat}% BF"
      else
        xml.set
      end
    end
  end

end
