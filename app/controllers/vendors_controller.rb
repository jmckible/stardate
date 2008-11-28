class VendorsController < ApplicationController
  
  # GET /vendors
  def index
    @vendors = current_user.vendors
  end
  
end