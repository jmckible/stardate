class ItemsController < ApplicationController

  # GET /items
  def index
    if params[:date]
      year  = params[:date][:year]  ? params[:date][:year].to_i  : Time.now.to_date.year
      month = params[:date][:month] ? params[:date][:month].to_i : Time.now.to_date.month
    else
      year = Time.now.to_date.year
      month = Time.now.to_date.month
    end
    
    @period = Date.new(year, month, 1)..Date.civil(year, month, -1)
    
    if @period.first < @user.created_at.to_date
      @period = @user.created_at.beginning_of_month.to_date..@user.created_at.end_of_month.to_date
    end
    
    @items = @household.items.during @period
  end

  # GET /items/:id
  def show
    @item = @household.items.find params[:id]
    render layout: false
  end

  # PUT /items/:id
  def update
    @item = @household.items.find params[:id]
    @item.update_attributes params[:item]
    redirect_back_or root_url
  end

  # DELETE /items/:id
  def destroy
    @item = @household.items.find params[:id]
    @item.destroy
    redirect_back_or root_url
  end

end
