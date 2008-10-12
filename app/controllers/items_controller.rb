class ItemsController < ApplicationController

  # GET /
  # GET /items
  def index
    @period = (Date.today - 4)..Date.today
    @item   = current_user.items.build
  end

  # GET /items/:id
  def show
    @item = current_user.items.find params[:id]
    render :layout=>false
  end

  # POST /items
  def create
    @item = current_user.items.build params[:item]
    @item.save
    redirect_to items_url
  end

  # PUT /items/:id
  def update
    @item = current_user.items.find(params[:id])
    @item.update_attributes params[:item]
    redirect_to request.env['HTTP_REFERER'] || items_url
  end

  # DELETE /items/:id
  def destroy
    @item = current_user.items.find params[:id]
    @item.destroy
    redirect_to items_url
  end

end
