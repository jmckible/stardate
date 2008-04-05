class RecurringsController < ApplicationController
  
  # GET /recurrings
  # GET /recurrings.xml
  def index
    @recurrings = current_user.recurrings.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml=>@recurrings.to_xml(:except=>:user_id) }
    end
  end

  # GET /recurrings/1.xml
  def show
    @recurring = current_user.recurrings.find(params[:id])

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @recurring.to_xml(:except=>:user_id) }
    end
  end

  # GET /recurrings/new
  def new
    @recurring = current_user.recurrings.build
  end

  # GET /recurrings/1/edit
  def edit
    @recurring = current_user.recurrings.find(params[:id])
  end

  # POST /recurrings
  # POST /recurrings.xml
  def create
    @recurring = current_user.recurrings.build(params[:recurring])

    respond_to do |format|
      if @recurring.save
        flash[:notice] = 'Recurring was successfully created.'
        format.html { redirect_to recurrings_url }
        format.xml  { head :created, :location => recurring_url(@recurring) }
      else
        format.html { render :action=>:new }
        format.xml  { render :xml=>@recurring.errors.to_xml }
      end
    end
  end

  # PUT /recurrings/1
  # PUT /recurrings/1.xml
  def update
    @recurring = current_user.recurrings.find(params[:id])

    respond_to do |format|
      if @recurring.update_attributes(params[:recurring])
        flash[:notice] = 'Recurring was successfully updated.'
        format.html { redirect_to recurrings_url }
        format.xml  { head :ok }
      else
        format.html { render :action=>:edit }
        format.xml  { render :xml=>@recurring.errors.to_xml }
      end
    end
  end

  # DELETE /recurrings/1
  # DELETE /recurrings/1.xml
  def destroy
    @recurring = current_user.recurrings.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to recurrings_url }
      format.xml  { head :ok }
    end
  end
end
