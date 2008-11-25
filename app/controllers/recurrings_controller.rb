class RecurringsController < ApplicationController
  
  # GET /recurrings
  def index
    @recurrings = current_user.recurrings
  end

  # GET /recurrings/new
  def new
    @recurring = current_user.recurrings.build
    render :layout=>false
  end

  # GET /recurrings/1
  def show
    @recurring = current_user.recurrings.find params[:id]
    render :layout=>false
  end

  # POST /recurrings
  def create
    @recurring = current_user.recurrings.build params[:recurring]
    @recurring.save
    redirect_to recurrings_url
  end

  # PUT /recurrings/1
  def update
    @recurring = current_user.recurrings.find params[:id]
    @recurring.update_attributes(params[:recurring])
    redirect_to recurrings_url
  end

  # DELETE /recurrings/1
  def destroy
    @recurring = current_user.recurrings.find(params[:id]).destroy
    redirect_to recurrings_url
  end
  
end
