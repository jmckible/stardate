class ImagesController < ApplicationController
  
  # GET /images/:id
  def show
    @image = Image.find params[:id]
    render :file=>"#{Rails.root}/public/404.html", :status=>404 and return unless @image.item.user == current_user
    render :layout=>false
  end
  
  # DELETE /images/:id
  def destroy
    @image = Image.find params[:id]
    @image.destroy if @image.item.user == current_user
    redirect_to request.env['HTTP_REFERER'] || root_url
  end

end
