class RecurringsController < ApplicationController
  
  # GET /recurrings
  def index
    @recurrings = current_user.recurrings
  end

  # GET /recurrings/new
  def new
    @recurring = current_user.recurrings.build
  end

  # GET /recurrings/1/edit
  def edit
    @recurring = current_user.recurrings.find params[:id]
  end

  # POST /recurrings
  def create
    @recurring = current_user.recurrings.build params[:recurring]
    if @recurring.save
      flash[:notice] = 'Recurring was successfully created.'
      redirect_to recurrings_url
    else
      render :action=>:new
    end
  end

  # PUT /recurrings/1
  def update
    @recurring = current_user.recurrings.find params[:id]
    if @recurring.update_attributes(params[:recurring])
      flash[:notice] = 'Recurring was successfully updated.'
      redirect_to recurrings_url
    else
      render :action=>:edit
    end
  end

  # DELETE /recurrings/1
  def destroy
    @recurring = current_user.recurrings.find(params[:id]).destroy
    redirect_to recurrings_url
  end
end
