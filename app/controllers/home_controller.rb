class HomeController < ApplicationController

  # GET /home
  def index
    @period = TimePeriod.month_to_date
    
    # If no activity this month, try the last week
    @period = @week if current_user.items.during(@period).size == 0
    
    # If no activity in the last week, punt
    @period = nil if current_user.items.during(@period).size == 0
    
    # Instatiate to set dates for correct timezone
    @item = current_user.items.build :date=>TzTime.now.to_date
    @task = Task.new :date=>TzTime.now.to_date
  end

end
