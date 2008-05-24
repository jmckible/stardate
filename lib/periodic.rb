module Periodic
  def self.included(base)
    base.send :helper_method, :period_assign_whole_month, :period_assign_to_today
  end
  
  protected
  
  # Takes in parameters in the form /:year/:month/:day/:period
  # Assigns @period to a range of dates from the implied start to end
  # For example:
  #   /             =>    First of current month, to the end of the month
  #   /2007         =>    January 1, 2007 - December 31, 2007
  #   /2007/1       =>    January 1, 2007 - January 31, 2007
  #   /2007/1/1     =>    January 1, 2007 - Janauary 1, 2007
  #   /2007/1/1/90  =>    January 1, 2007 - April 1, 2007
  def period_assign_whole_month
    params[:period].nil? ? period = 0 : period = params[:period].to_i
    params[:year].nil? ? year = TzTime.now.year : year = params[:year].to_i

    if params[:day].nil?
      day = 1
      if params[:month].nil?
        month = 1
        if params[:year].nil?
          year, month, day = TzTime.now.year, TzTime.now.month, 1
          period += (Date.civil(year, month, -1).day - 1)
        else
          Date.new(year).leap? ? period += 365 : period += 364
        end
      else
        month = params[:month].to_i
        period += (Date.civil(year, month, -1).day - 1)
      end
    else
      month = params[:month].to_i
      day = params[:day].to_i
    end

    @period = Date.new(year, month, day)..(Date.new(year, month, day) + period)
  end
  
  # Takes in parameters in the form /:year/:month/:day/:period
  # Assigns @period to a range of dates from the implied start to end
  # Will only returns a period up to today
  def period_assign_to_today
    year, month, day, period = params[:year], params[:month], params[:day], params[:period]

    if period.nil?
      if day.nil?
        if month.nil?
          if year.nil?
            @period = Date.new(TzTime.now.year, TzTime.now.month, 1)..TzTime.now.to_date
          else
            year = year.to_i
            @period = Date.new(year, 1, 1)..Date.new(year, 12, 31)
          end
        else
          year, month = year.to_i, month.to_i
          @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
        end
      else
        year, month, day = year.to_i, month.to_i, day.to_i
        @period = Date.new(year, month, 1)..Date.new(year, month, day)
      end
    else
      year, month, day, period = year.to_i, month.to_i, day.to_i, period.to_i
      @period = Date.new(year, month, day)..(Date.new(year, month, day) + period)     
    end
  end
end