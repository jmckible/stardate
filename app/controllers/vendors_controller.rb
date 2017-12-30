class VendorsController < ApplicationController

  # GET /vendors
  def index
    @vendors = @household.vendors.visible_by(@user).page params[:page]
  end

  # GET /vendors/:id
  def show
    @vendor = Vendor.find_by! permalink: params[:id]
    @transactions = @household.transactions.from_vendor(@vendor).visible_by(@user).order(date: :desc).page params[:page]
  end

end
