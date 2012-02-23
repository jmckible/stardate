class P90xesController < ApplicationController
  
  # GET /p90xes/:id
  def show
    @p90x = current_user.p90xes.find params[:id]
    render :layout=>false
  end
  
  # PUT /p90xes/:id
  def update
    @p90x = current_user.p90xes.find params[:id]
    @p90x.update_attributes params[:p90x]
    redirect_to root_url
  end
  
  # DELETE /p90xes/:id
  def destroy
    @p90x = current_user.p90xes.find params[:id]
    @p90x.destroy
    redirect_to root_url
  end
  
end
