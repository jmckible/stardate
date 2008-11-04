class ItemsController < ApplicationController

  # GET /
  # GET /items
  def index
    @items = current_user.items.during((Date.today - 4)..Date.today)
    @item  = current_user.items.build :value=>nil
    @notes = current_user.notes.during((Date.today - 4)..Date.today)
    @note  = current_user.notes.build
  end

  # GET /items/:id
  def show
    @item = current_user.items.find params[:id]
    render :layout=>false
  end

  # POST /items
  def create
    @vendor = params[:vendor] ? Vendor.find_or_create_by_name(params[:vendor][:name]) : nil
    @item = current_user.items.build params[:item].merge(:vendor=>@vendor)
    @item.save
    redirect_to root_url
  end

  # PUT /items/:id
  def update
    @vendor = params[:vendor] ? Vendor.find_or_create_by_name(params[:vendor][:name]) : nil
    @item = current_user.items.find params[:id]
    @item.update_attributes params[:item].merge(:vendor=>@vendor)
    redirect_to request.env['HTTP_REFERER'] || root_url
  end

  # DELETE /items/:id
  def destroy
    @item = current_user.items.find params[:id]
    @item.destroy
    redirect_to root_url
  end

end
