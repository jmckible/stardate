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
    @items  = @user.items.during @period
  end

  # GET /items/:id
  def show
    @item = @user.items.find params[:id]
    render layout: false
  end

  # PUT /items/:id
  def update
    @item = @user.items.find params[:id]
    @item.update_attributes params[:item]
    redirect_back_or root_url
  end

  # DELETE /items/:id
  def destroy
    @item = @user.items.find params[:id]
    @item.destroy
    redirect_back_or root_url
  end

end
