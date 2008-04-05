class JobsController < ApplicationController
  
  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = current_user.jobs.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs.to_xml(:except=>[:user_id, :created_at]) }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = current_user.jobs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job.to_xml(:except=>[:user_id, :created_at]) }
    end
  end

  # GET /jobs/new
  def new
    @job = current_user.jobs.new
  end

  # GET /jobs/1;edit
  def edit
    @job = current_user.jobs.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = current_user.jobs.build params[:job]

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to job_url(@job) }
        format.xml  { head :created, :location => job_url(@job) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors.to_xml }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = current_user.jobs.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to job_url(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors.to_xml }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = current_user.jobs.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.xml  { head :ok }
    end
  end
end
