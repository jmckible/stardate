class ItemsController < ApplicationController

  # GET /
  # GET /items
  def index
    @period = Date.today..(Date.today - 4)
    @item   = current_user.items.build
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
  def create
    @item = current_user.items.build params[:item]
    @item.save
    redirect_to items_path
  end

  # PUT /items/1
  def update
    @item = current_user.items.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = 'Item was successfully updated.'
      unless params[:redbox].nil?
        redirect_to home_path
      else
        redirect_to register_path(:year=>@item.date.year, :month=>@item.date.month)
      end
    else
      render :action=>:edit
    end
  end

  # DELETE /items/1
  def destroy
    @item = current_user.items.find(params[:id])
    date = @item.date
    @item.destroy
    redirect_to register_path(:year=>date.year, :month=>date.month)
  end
  
  # DELETE /items/1/redbox_destroy
  def redbox_destroy
    @item = current_user.items.find(params[:id]).destroy
    redirect_to home_url
  end

end
