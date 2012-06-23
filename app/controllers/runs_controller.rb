class RunsController < ApplicationController
  
  # GET /runs/:id
  def show
    @run = @user.runs.find params[:id]
    render layout: false
  end
  
  # PUT /runs/:id
  def update
    @run = @user.runs.find params[:id]
    @run.update_attributes params[:run]
    redirect_back_or root_url
  end
  
  # DELETE /runs/:id
  def destroy
    @run = @user.runs.find params[:id]
    @run.destroy
    redirect_back_or root_url
  end
  
end
