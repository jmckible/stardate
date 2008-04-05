class ItemsController < ApplicationController
  
  # GET /items.xml
  # GET /items.xml?&offset=50
  # GET /items.xml?&on=20070101
  # GET /items.xml?&on=20070101&offest=50
  def index 
    offset = params[:offset].to_i
    
    if params[:on].nil?
      @items = current_user.items.find(:all, :offset=>offset, :limit=>50)
    else
      date = Date.parse(params[:on])
      @items = current_user.items.find(:all, :offset=>offset, :limit=>50, :conditions=>{:date=>date})
    end
    
    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @items.to_xml(:except=>:user_id) }
    end
  end

  # GET /items/1.xml
  def show
    @item = current_user.items.find(params[:id])

    respond_to do |format|
      format.html { render :nothing=>true, :status=>404 }
      format.xml  { render :xml => @item.to_xml(:except=>:user_id) }
    end
  end

  # GET /items/new
  def new
    @item = current_user.items.build :date=>TzTime.today.to_date
  end

  # GET /items/1/edit
  # GET /items/1/redbox
  def edit
    @item = current_user.items.find(params[:id])
    respond_to do |format|
      format.js { render :action=>:redbox_edit, :layout=>false }
      format.html 
    end
  end

  # POST /items
  # POST /items.xml
  def create
    @item = current_user.items.build(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to home_path }
        format.xml  { head :created, :location => item_url(@item) }
      else
        format.html { render :action=>:new }
        format.xml  { render :xml=>@item.errors.to_xml }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = current_user.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html do 
          unless params[:redbox].nil?
            redirect_to home_path
          else
            redirect_to register_path(:year=>@item.date.year, :month=>@item.date.month)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action=>:edit }
        format.xml  { render :xml=>@item.errors.to_xml }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = current_user.items.find(params[:id])
    date = @item.date
    @item.destroy

    respond_to do |format|
      format.html { redirect_to register_path(:year=>date.year, :month=>date.month) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /items/1/redbox_destroy
  def redbox_destroy
    @item = current_user.items.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to home_url }
      format.xml  { head :ok }
    end
  end

end
