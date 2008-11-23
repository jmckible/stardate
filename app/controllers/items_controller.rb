class ItemsController < ApplicationController

  # GET /
  # GET /items
  def index
    @things = current_user.stuff_during((Date.today - 3)..Date.today)
  end

  # GET /items/:id
  def show
    @item = current_user.items.find params[:id]
    render :layout=>false
  end

  # PUT /items/:id
  def update
    @item = current_user.items.find params[:id]
    @item.update_attributes params[:item]
    redirect_to request.env['HTTP_REFERER'] || root_url
  end

  # DELETE /items/:id
  def destroy
    @item = current_user.items.find params[:id]
    @item.destroy
    redirect_to root_url
  end

end
