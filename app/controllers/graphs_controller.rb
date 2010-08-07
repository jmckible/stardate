class GraphsController < ApplicationController
  
  # GET /graphs/health
  def health
    set_period
    respond_to do |format|
      format.xml do
        if @period.to_a.length > 31
          render :action=>'health_year.xml.builder'
        else
          render :action=>'health_month.xml.builder'
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
  end

end