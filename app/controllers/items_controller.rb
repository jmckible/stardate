class ItemsController < ApplicationController

  # GET /
  # GET /items
  def index
    @period = (Date.today - 4)..Date.today
    @item   = current_user.items.build
  end

  # GET /items/:id
  def show
    @item = current_user.items.find params[:id]
    render :layout=>false
  end

  # POST /items
  def create
    @item = current_user.items.build params[:item]
    @item.save
    redirect_to items_path
  end

  # PUT /items/:id
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

  # DELETE /items/:id
  def destroy
    @item = current_user.items.find(params[:id])
    @item.destroy
    redirect_to items_path
  end

end
