class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = current_user.vendors
  end
  
  # GET /vendors/:id
  def show
    @vendor = Vendor.find_by_permalink params[:id]
    
    respond_to do |format|
      format.html { @items  = current_user.items.from_vendor(@vendor).paginate :page=>params[:page]}
      format.xml  { @period = Date.new(2007,1,1)..Time.now.to_date }
    end
  end
  
end