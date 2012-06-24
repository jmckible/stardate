class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = @user.vendors.page params[:page]
  end
  
  # GET /vendors/:id
  def show
    @vendor = Vendor.find params[:id]
    
    respond_to do |format|
      format.html { @items  = @user.items.from_vendor(@vendor).order('date DESC').page params[:page]}
      format.xml  { @period = Date.new(2007,1,1)..Time.now.to_date }
    end
  end
  
end