xml.chart chartLeftMargin: 0, showBorder: 0, bgColor: 'ffffff', showValues: 0, numberPrefix: '$', plotGradientColor: '', formatNumberScale: 0, showLegend: 0 do
  xml.categories do
    @period.step(7) do |date|
      if date.month != (date - 7).month || date == @period.first
        xml.category label: date.strftime('%b %e')
      else
        xml.category label: ''
      end
    end
  end

  xml.dataSet seriesName: 'Income', color: '00CCFF' do
    sum = 0
    @period.step(7) do |date|
      sum += @user.sum_income(date..(date+6))
      xml.set value: sum
    end
  end

  xml.dataSet seriesName: 'Expenses', color: 'FF00CC' do
    sum = 0
    @period.step(7) do |date|
      sum += (@user.sum_expenses(date..(date+6)) * -1)
      xml.set value: sum
    end
  end

end
