class GraphsController < ApplicationController
  
  # GET /graphs/running.xml
  def running
    @period = (Time.now.to_date - 30)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end
  
  # GET /graphs/spending.xml
  def spending
    @period = (Time.now.to_date - 30)..Time.now.to_date
    respond_to do |format|
      format.xml
    end
  end
  
end