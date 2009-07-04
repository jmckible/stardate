class GraphsController < ApplicationController
  
  # GET /graphs/running_month
  def running_month
    @period = (Time.now.to_date - 30)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end
  
  # GET /graphs/running_year
  def running_year
    @period = (Time.now.to_date - 365)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end
  
  # GET /graphs/spending_month
  def spending_month
    @period = (Time.now.to_date - 30)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end
  
  # GET /graphs/spending_year
  def spending_year
    @period = (Time.now.to_date - 365)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end

end