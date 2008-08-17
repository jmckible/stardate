class JobsController < ApplicationController
  
  # GET /jobs
  def index
    @jobs = current_user.jobs.find :all
  end

  # GET /jobs/1
  def show
    @job = current_user.jobs.find params[:id]
  end

  # GET /jobs/new
  def new
    @job = current_user.jobs.new
  end

  # GET /jobs/1;edit
  def edit
    @job = current_user.jobs.find params[:id]
  end

  # POST /jobs
  def create
    @job = current_user.jobs.build params[:job]
    if @job.save
      flash[:notice] = 'Job was successfully created.'
      redirect_to job_url(@job)
    else
      render :action=>:new
    end
  end

  # PUT /jobs/1
  def update
    @job = current_user.jobs.find params[:id]
    if @job.update_attributes(params[:job])
      flash[:notice] = 'Job was successfully updated.'
      redirect_to job_url(@job)
    else
      render :action=>:edit
    end
  end

  # DELETE /jobs/1
  def destroy
    @job = current_user.jobs.find(params[:id]).destroy
    redirect_to jobs_url
  end
end
