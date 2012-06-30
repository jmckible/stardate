class WorkoutsController < ApplicationController
  
  # GET /workouts
  def index
    
    begin
      @start = Date.new params[:start][:year].to_i, params[:start][:month].to_i, params[:start][:day].to_i
    rescue
      @start = Time.now.to_date - 365
    end
    
    begin
      @finish = Date.new params[:finish][:year].to_i, params[:finish][:month].to_i, params[:finish][:day].to_i
    rescue
      @finish = Time.now.to_date
    end
    @period = @start..@finish
    
    @workouts = @user.workouts.order('date DESC').page params[:page]
  end
  
  # GET /workouts/:id
  def show
    @workout = @user.workouts.find params[:id]
    render layout: false
  end
  
  # PUT /workouts/:id
  def update
    @workout = @user.workouts.find params[:id]
    @workout.update_attributes params[:workout]
    redirect_back_or root_url
  end
  
  # DELETE /workouts/:id
  def destroy
    @workout = @user.workouts.find params[:id]
    @workout.destroy
    redirect_back_or root_url
  end
  
end