class NikesController < ApplicationController
  
  # GET /nikes/:id
  def show
    @nike = current_user.nikes.find params[:id]
    render :layout=>false
  end
  
  # PUT /nikes/:id
  def update
    @nike = current_user.nikes.find params[:id]
    @nike.update_attributes params[:nike]
    redirect_to root_url
  end
  
  # DELETE /nikes/:id
  def destroy
    @nike = current_user.nikes.find params[:id]
    @nike.destroy
    redirect_to root_url
  end
  
end
