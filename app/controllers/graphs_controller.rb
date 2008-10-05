class GraphsController < ApplicationController
  
  layout false
  
  # GET /graphs/activity.xml
  # GET /graphs/activity.xml/2007
  # GET /graphs/activity.xml/2007/1
  # GET /graphs/activity.xml/2007/1/1
  # GET /graphs/activity.xml/2007/1/1/31
  def activity
    period_assign_to_today
    respond_to do |format|
      format.xml do
        case @period.last - @period.first
        when 0..31
          render :action=>:activity_daily
        when 32..140
          render :action=>:activity_weekly
        else
          render :action=>:activity_monthly
        end
      end
    end
  end
  
end
