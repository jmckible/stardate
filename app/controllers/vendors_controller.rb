class VendorsController < ApplicationController

  # GET /vendors
  def index
    @vendors = Current.household.vendors.visible_by(Current.user).page params[:page]
  end

  # GET /vendors/:id
  def show
    @vendor = Vendor.find_by! permalink: params[:id]
    @transactions = Current.household.transactions.from_vendor(@vendor).visible_by(Current.user).order(date: :desc).page params[:page]
  end

end
