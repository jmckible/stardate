class GraphsController < ApplicationController
  
  # GET /graphs/spending.xml
  def spending
    @period = (Date.today - 30)..Date.today
    respond_to do |format|
      format.xml
    end
  end
  
end