class RunsController < ApplicationController
  
  # GET /runs/:id
  def show
    @run = current_user.runs.find params[:id]
    render :layout=>false
  end
  
  # PUT /runs/:id
  def update
    @run = current_user.runs.find params[:id]
    @run.update_attributes params[:run]
    redirect_to root_url
  end
  
  # DELETE /runs/:id
  def destroy
    @run = current_user.runs.find params[:id]
    @run.destroy
    redirect_to root_url
  end
  
end
