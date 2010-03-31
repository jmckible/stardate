class WeightsController < ApplicationController
  
  # GET /weights/:id
  def show
    @weight = current_user.weights.find params[:id]
    render :layout=>false
  end
  
  # PUT /weights/:id
  def update
    @weight = current_user.weights.find params[:id]
    @weight.update_attributes params[:weight]
    redirect_to root_url
  end
  
  # DELETE /weights/:id
  def destroy
    @weight = current_user.weights.find params[:id]
    @weight.destroy
    redirect_to root_url
  end
  
end
