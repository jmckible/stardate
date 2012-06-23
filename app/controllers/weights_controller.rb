class WeightsController < ApplicationController
  
  # GET /weights/:id
  def show
    @weight = @user.weights.find params[:id]
    render layout: false
  end
  
  # PUT /weights/:id
  def update
    @weight = @user.weights.find params[:id]
    @weight.update_attributes params[:weight]
    redirect_back_or root_url
  end
  
  # DELETE /weights/:id
  def destroy
    @weight = @user.weights.find params[:id]
    @weight.destroy
    redirect_back_or root_url
  end
  
end
