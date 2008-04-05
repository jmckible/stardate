class TasksController < ApplicationController
  
  # GET /tasks.xml
  # GET /tasks.xml?&offset=50
  # GET /tasks.xml?&on=20070101
  # GET /tasks.xml?&on=20070101&offest=50
  # GET /tasks.xml?&job_id=1
  # GET /tasks.xml?&job_id=1&on=20070101
  # GET /tasks.xml?&job_id=1&on=20070101&offset=50
  def index
    offset = params[:offset].to_i
    
    # UGLY CODE ALERT
    if params[:job_id].nil?
      if params[:on].nil?
        @tasks = current_user.tasks.find(:all, :offset=>offset, :limit=>50)
      else
        date = Date.parse(params[:on])
        @tasks = current_user.tasks.find(:all, :offset=>offset, :limit=>50, :conditions=>{:date=>date})
      end
    else
      project = current_user.jobs.find(params[:job_id])
      if params[:on].nil?
        @tasks = project.tasks.find(:all, :offset=>offset, :limit=>50)
      else
        date = Date.parse(params[:on])
        @tasks = project.tasks.find(:all, :offset=>offset, :limit=>50, :conditions=>{:date=>date})
      end
    end

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @tasks.to_xml(:except=>:created_at) }
    end
  end

  # GET /tasks/1.xml
  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @task.to_xml(:except=>:created_at) }
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    # Must manually assign job because it is a protected attribute
    @task.job = current_user.jobs.find(params[:task][:job_id])

    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to home_path }
        format.xml  { head :created, :location => task_url(@task) }
      else
        format.html { render :action=>'new' }
        format.xml  { render :xml => @task.errors.to_xml }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = current_user.tasks.find(params[:id])
    # Tasks may not change job, so no assigment like the Create action

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to job_url(@task.job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors.to_xml }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = current_user.tasks.find(params[:id])
    job = @task.job
    @task.destroy

    flash[:notice] = 'Task was deleted'

    respond_to do |format|
      format.html { redirect_to job_url(job) }
      format.xml  { head :ok }
    end
  end
end
