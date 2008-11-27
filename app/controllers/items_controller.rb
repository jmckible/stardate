class ItemsController < ApplicationController

  # GET /items
  def index
    if params[:date]
      year  = params[:date][:year]  ? params[:date][:year].to_i  : Date.today.year
      month = params[:date][:month] ? params[:date][:month].to_i : Date.today.month
    else
      year = Date.today.year
      month = Date.today.month
    end
    
    @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
    @items  = current_user.items.during @period
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
    redirect_to request.env['HTTP_REFERER'] || root_url
  end

end
