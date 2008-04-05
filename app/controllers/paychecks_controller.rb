class PaychecksController < ApplicationController
  before_filter :load_job
  
  # GET /jobs/1/paychecks.xml
  # GET /jobs/1/paychecks.xml?&offset=50
  def index
    offset = params[:offset].to_i
    @paychecks = @job.paychecks.find(:all, :limit=>50, :offset=>offset)

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @paychecks.to_xml(:except=>[:job_id]) }
    end
  end

  # GET /jobs/1/paychecks/1.xml
  def show
    @paycheck = @job.paychecks.find(params[:id])

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @paycheck.to_xml(:except=>[:job_id]) }
    end
  end

  # GET /jobs/1/paychecks/new
  def new
    @paycheck = @job.paychecks.build
  end

  # GET /jobs/1/paychecks/1/edit
  def edit
    @paycheck = @job.paychecks.find(params[:id])
  end

  # POST /jobs/1/paychecks
  # POST /jobs/1/paychecks.xml
  def create
    @paycheck = @job.paychecks.build(params[:paycheck])

    respond_to do |format|
      if @paycheck.save
        flash[:notice] = 'Paycheck was successfully created.'
        format.html { redirect_to job_url(@job) }
        format.xml  { head :created, :location => job_paycheck_url(@job, @paycheck) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paycheck.errors.to_xml }
      end
    end
  end

  # PUT /jobs/1/paychecks/1
  # PUT /jobs/1/paychecks/1.xml
  def update
    @paycheck = @job.paychecks.find(params[:id])

    respond_to do |format|
      if @paycheck.update_attributes(params[:paycheck])
        flash[:notice] = 'Paycheck was successfully updated.'
        format.html { redirect_to job_url(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck.errors.to_xml }
      end
    end
  end

  # DELETE /jobs/1/paychecks/1
  # DELETE /jobs/1/paychecks/1.xml
  def destroy
    @paycheck = @job.paychecks.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to job_url(@job) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def load_job
    @job = current_user.jobs.find(params[:job_id])
  end
end
