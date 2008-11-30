class GraphsController < ApplicationController
  
  # GET /graphs/running.xml
  def running
    @period = (Date.today - 30)..Date.today
    respond_to do |format|
      format.xml
    end
  end
  
  # GET /graphs/spending.xml
  def spending
    @period = (Date.today - 30)..Date.today
    respond_to do |format|
      format.xml
    end
  end
  
end