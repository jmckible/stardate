class PaychecksController < ApplicationController
  before_filter :load_job

  # GET /jobs/1/paychecks/new
  def new
    @paycheck = @job.paychecks.build
  end

  # GET /jobs/1/paychecks/1/edit
  def edit
    @paycheck = @job.paychecks.find params[:id]
  end

  # POST /jobs/1/paychecks
  def create
    @paycheck = @job.paychecks.build params[:paycheck]
    if @paycheck.save
      flash[:notice] = 'Paycheck was successfully created.'
      redirect_to job_url(@job)
    else
      render :action=>:new
    end
  end

  # PUT /jobs/1/paychecks/1
  def update
    @paycheck = @job.paychecks.find(params[:id])
    if @paycheck.update_attributes(params[:paycheck])
      flash[:notice] = 'Paycheck was successfully updated.'
      redirect_to job_url(@job)
    else
      render :action=>:edit
    end
  end

  # DELETE /jobs/1/paychecks/1
  def destroy
    @paycheck = @job.paychecks.find(params[:id]).destroy
    redirect_to job_url(@job)
  end
  
  protected
  def load_job
    @job = current_user.jobs.find params[:job_id]
  end
end
