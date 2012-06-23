class RecurringsController < ApplicationController
  
  # GET /recurrings
  def index
    @recurrings = @user.recurrings
  end

  # GET /recurrings/new
  def new
    @recurring = @user.recurrings.build
    render layout: false
  end

  # GET /recurrings/1
  def show
    @recurring = @user.recurrings.find params[:id]
    render layout: false
  end

  # POST /recurrings
  def create
    @recurring = @user.recurrings.build params[:recurring]
    @recurring.save
    redirect_to recurrings_url
  end

  # PUT /recurrings/:id
  def update
    @recurring = @user.recurrings.find params[:id]
    @recurring.update_attributes params[:recurring]
    redirect_to recurrings_url
  end

  # DELETE /recurrings/:id
  def destroy
    @recurring = @user.recurrings.find params[:id]
    @recurring.destroy
    redirect_to recurrings_url
  end
  
end
