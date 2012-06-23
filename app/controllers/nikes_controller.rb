class NikesController < ApplicationController
  
  # GET /nikes/:id
  def show
    @nike = @user.nikes.find params[:id]
    render layout: false
  end
  
  # PUT /nikes/:id
  def update
    @nike = @user.nikes.find params[:id]
    @nike.update_attributes params[:nike]
    redirect_to request.env['HTTP_REFERER'] || root_url
  end
  
  # DELETE /nikes/:id
  def destroy
    @nike = @user.nikes.find params[:id]
    @nike.destroy
    redirect_to request.env['HTTP_REFERER'] || root_url
  end
  
end
