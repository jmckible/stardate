xml.chart :showValues=>'0', :showBorder=>0, :bgColor=>'ffffff',  :plotGradientColor=>'' do 
  
  @period.each do |date|
    if date.mday.modulo(2) == 0
      label = ''
    elsif date.mday == 1
      label = date.strftime('%b %e')
    else
      label = date.day
    end
    xml.set :label=>label, :value=>current_user.runs.on(date).sum(:distance)
  end
  
end