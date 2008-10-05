class GraphsController < ApplicationController
  
  layout false
  
  # GET /graphs/activity.xml
  # GET /graphs/activity.xml/2007
  # GET /graphs/activity.xml/2007/1
  # GET /graphs/activity.xml/2007/1/1
  # GET /graphs/activity.xml/2007/1/1/31
  def activity
    period_assign_to_today
  end
  
end
