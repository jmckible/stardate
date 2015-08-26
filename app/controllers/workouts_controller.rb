class WorkoutsController < ApplicationController

  # GET /workouts
  def index
    set_period
    @workouts = @user.workouts.order(date: :desc).page params[:page]
  end

  # GET /workouts/:id
  def show
    @workout = @user.workouts.find params[:id]
    render layout: false
  end

  # PUT /workouts/:id
  def update
    @workout = @user.workouts.find params[:id]
    @workout.update_attributes params.require(:workout).permit(:date, :minutes, :description, :distance)
    redirect_back_or root_url
  end

  # DELETE /workouts/:id
  def destroy
    @workout = @user.workouts.find params[:id]
    @workout.destroy
    redirect_back_or root_url
  end

end
