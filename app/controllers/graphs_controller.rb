class GraphsController < ApplicationController
  
  # GET /graphs/running
  def running
    set_period
    respond_to do |format|
      format.xml do
        if @period.to_a.length > 31
          render :action=>'running_year.xml.builder'
        else
          render :action=>'running_month.xml.builder'
        end
      end
    end
  end
  
  # GET /graphs/spending
  def spending
    set_period
    respond_to do |format|
      format.xml do
        if @period.to_a.length > 31
          render :action=>'spending_year.xml.builder'
        else
          render :action=>'spending_month.xml.builder'
        end
      end
    end
  end
  
  # GET /graphs/weighing
  def weighing
    set_period
    respond_to do |format|
      format.xml
    end
  end
  
  protected
  def set_period
    begin
      @start = Date.parse params[:start]
    rescue
      @start = Time.now.to_date - 30
    end
    begin
      @finish = Date.parse params[:finish]
    rescue
      @finish = Time.now.to_date
    end
    @period = @start..@finish
    logger.info "start: #{@start}"
    logger.info "finish: #{@finish}"
    logger.info "period: #{@period.first}-#{@period.last}"
  end

end