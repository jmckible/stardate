module Calendar
  class Splicer
    # Takes a Range of dates and returns an array of Ranges organized by month
    def self.by_month(period)
      months = Array.new
      start = nil
      period.each do |day|
        start = day if start.nil?
        if start.month != day.month
          month = start..(day - 1)
          months << month
          start = day
        end
      end
      month = start..period.last
      months << month
      return months
    end

    # Takes a range of dates and returns a hash like [2006 => [1/1/06..1/31/06, 2/1/06..2/28/06, ...]]
    def self.by_year_by_month(period)
      months = self.by_month(period)
      
      years = Hash.new
      months.each do |month|
        year = years[month.first.year]
        year = Array.new if year.nil?
        year << month
        years[month.first.year] = year
      end
      
      return years.sort
    end

  end
end