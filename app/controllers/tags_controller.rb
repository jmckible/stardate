class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = @household.tags.since(@user.created_at).page params[:page]
  end
  
  # GET /tags/:id
  def show
    @tag = Tag.find params[:id]
    @period = @user.created_at.to_date..Date.today
    @items = @household.items.tagged_with(@tag).since(@user.created_at).page(params[:page])
  end
  
end