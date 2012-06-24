class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = @user.tags.page params[:page]
  end
  
  # GET /tags/:id
  def show
    @tag = Tag.find params[:id]
    @period = Date.new(2007,1,1)..Time.now.to_date
    @items = @user.items.tagged_with(@tag).page(params[:page])
  end
  
end