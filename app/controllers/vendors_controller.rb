class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = @household.vendors.page params[:page]
  end
  
  # GET /vendors/:id
  def show
    @vendor = Vendor.find params[:id]
    @items  = @household.items.from_vendor(@vendor).order('date DESC').page params[:page]
  end
  
end