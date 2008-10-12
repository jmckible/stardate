class GraphsController < ApplicationController
  
  layout false
  
  # GET /graphs/activity
  def activity
    @period = (Date.today - 30)..Date.today
    render :action=>'activity.xml.builder'
  end
  
end
