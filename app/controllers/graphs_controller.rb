class GraphsController < ApplicationController
  before_filter :period_assign_whole_month, :only=>[:in_out_bar, :tag_bubble]
  before_filter :period_assign_to_today,    :only=>[:activity]
  
  layout false
  
  # GET /graphs/activity.xml
  # GET /graphs/activity.xml/2007
  # GET /graphs/activity.xml/2007/1
  # GET /graphs/activity.xml/2007/1/1
  # GET /graphs/activity.xml/2007/1/1/31
  def activity
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
  
  # GET /graphs/in_out_bar.xml
  # GET /graphs/in_out_bar.xml/2007
  # GET /graphs/in_out_bar.xml/2007/1
  # GET /graphs/in_out_bar.xml/2007/1/1
  # GET /graphs/in_out_bar.xml/2007/1/1/31
  def in_out_bar
    respond_to do |format|
      format.xml
    end
  end
  
end
