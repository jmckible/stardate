class BikesController < ApplicationController
  
  # GET /bikes/:id
  def show
    @bike = @user.bikes.find params[:id]
    render layout: false
  end
  
  # PUT /bikes/:id
  def update
    @bike = @user.bikes.find params[:id]
    @bike.update_attributes params[:bike]
    redirect_to root_url
  end
  
  # DELETE /bikes/:id
  def destroy
    @bike = @user.bikes.find params[:id]
    @bike.destroy
    redirect_to root_url
  end
  
end
