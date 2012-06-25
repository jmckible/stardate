class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = @household.vendors.since(@user.created_at).page params[:page]
  end
  
  # GET /vendors/:id
  def show
    @vendor = Vendor.find params[:id]
    @items  = @household.items.from_vendor(@vendor).since(@user.created_at).order('date DESC').page params[:page]
  end
  
end