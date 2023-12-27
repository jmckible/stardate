class WorkoutsController < ApplicationController

  # GET /workouts
  def index
    set_period
    @workouts = Current.user.workouts.order(date: :desc).page params[:page]
  end

  # GET /workouts/:id
  def show
    @workout = Current.user.workouts.find params[:id]
    render layout: false
  end

  # PUT /workouts/:id
  def update
    @workout = Current.user.workouts.find params[:id]
    @workout.update params.require(:workout).permit(:date, :minutes, :description, :distance)
    redirect_back_or root_url
  end

  # DELETE /workouts/:id
  def destroy
    @workout = Current.user.workouts.find params[:id]
    @workout.destroy
    redirect_back_or root_url
  end

end
