class GraphsController < ApplicationController
  
  layout false
  
  # GET /graphs/activity.xml
  def activity
    @period = (Date.today - 30)..Date.today
  end
  
end
