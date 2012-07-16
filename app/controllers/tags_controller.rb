class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = @household.tags.visible_by(@user).page params[:page]
  end
  
  # GET /tags/:id
  def show
    @tag = Tag.find_by_permalink! params[:id]
    @period = @user.created_at.to_date..Time.now.to_date
    @items = @household.items.tagged_with(@tag).since(@user.created_at).page(params[:page])
  end
  
end