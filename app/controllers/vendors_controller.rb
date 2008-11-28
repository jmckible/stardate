class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = current_user.vendors
  end
  
  # GET /vendors/:id
  def show
    @vendor = Vendor.find params[:id]
  end
  
end