class EllipticalsController < ApplicationController
  
  # GET /ellipticals/:id
  def show
    @elliptical = @user.ellipticals.find params[:id]
    render layout: false
  end
  
  # PUT /ellipticals/:id
  def update
    @elliptical = @user.ellipticals.find params[:id]
    @elliptical.update_attributes params[:elliptical]
    redirect_to root_url
  end
  
  # DELETE /ellipticals/:id
  def destroy
    @elliptical = @user.ellipticals.find params[:id]
    @elliptical.destroy
    redirect_to root_url
  end
  
end
