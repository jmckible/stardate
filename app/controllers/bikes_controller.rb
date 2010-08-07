class BikesController < ApplicationController
  
  # GET /bikes/:id
  def show
    @bike = current_user.bikes.find params[:id]
    render :layout=>false
  end
  
  # PUT /bikes/:id
  def update
    @bike = current_user.bikes.find params[:id]
    @bike.update_attributes params[:bike]
    redirect_to root_url
  end
  
  # DELETE /bikes/:id
  def destroy
    @bike = current_user.bikes.find params[:id]
    @bike.destroy
    redirect_to root_url
  end
  
end
