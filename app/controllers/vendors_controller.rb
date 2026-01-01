class VendorsController < ApplicationController

  # GET /vendors
  def index
    @vendors = Current.household.vendors.visible_by(Current.user).page params[:page]

    # Precompute transaction counts and sums for all vendors to avoid N queries
    vendor_ids = @vendors.map(&:id)
    @vendor_stats = Current.household.transactions.visible_by(Current.user)
      .where(vendor_id: vendor_ids)
      .group(:vendor_id)
      .select('vendor_id, COUNT(*) as transaction_count, SUM(amount) as total_amount')
      .index_by(&:vendor_id)
  end

  # GET /vendors/:id
  def show
    @vendor = Vendor.find_by! permalink: params[:id]
    @transactions = Current.household.transactions.from_vendor(@vendor).visible_by(Current.user)
      .includes(:vendor, :tags, :debit, :credit, :user)
      .order(date: :desc)
      .page params[:page]
  end

end
