class RecurringsController < ApplicationController

  # GET /recurrings
  def index
    @recurrings = Current.user.recurrings.includes(:vendor, :tags, :debit, :credit)
  end

  # GET /recurrings/1
  def show
    @recurring = Current.user.recurrings.find params[:id]
    render layout: false
  end

  # GET /recurrings/new
  def new
    @recurring = Current.user.recurrings.build
    render layout: false
  end

  # POST /recurrings
  def create
    @recurring = Current.user.recurrings.build recurrings_params
    @recurring.save
    redirect_to recurrings_url
  end

  # PUT /recurrings/:id
  def update
    @recurring = Current.user.recurrings.find params[:id]
    @recurring.update recurrings_params
    redirect_to recurrings_url
  end

  # DELETE /recurrings/:id
  def destroy
    @recurring = Current.user.recurrings.find params[:id]
    @recurring.destroy
    redirect_to recurrings_url
  end

  protected
  def recurrings_params
    params.fetch(:recurring, {}).permit(:day, :amount, :vendor_name, :tag_list, :debit_id, :credit_id)
  end

end
