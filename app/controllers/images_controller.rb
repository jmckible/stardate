class ImagesController < ApplicationController
  
  # DELETE /images/:id
  def destroy
    @image = Image.find params[:id]
    @image.destroy if @image.item.user == current_user
    redirect_to request.env['HTTP_REFERER'] || root_url
  end

end
