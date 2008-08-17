class TasksController < ApplicationController

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  # POST /tasks
  def create
    @task = Task.new(params[:task])
    # Must manually assign job because it is a protected attribute
    @task.job = current_user.jobs.find(params[:task][:job_id])

    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to home_path
    else
      render :action=>:new
    end
  end

  # PUT /tasks/1
  def update
    @task = current_user.tasks.find(params[:id])
    # Tasks may not change job, so no assigment like the Create action

    if @task.update_attributes(params[:task])
      flash[:notice] = 'Task was successfully updated.'
      redirect_to job_url(@task.job)
    else
      render :action=>:edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task = current_user.tasks.find(params[:id])
    job = @task.job
    @task.destroy
    flash[:notice] = 'Task was deleted'
    redirect_to job_url(job)
  end
end
