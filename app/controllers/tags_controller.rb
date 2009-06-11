class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = current_user.items.tag_counts :order=>'count desc'
  end
  
  # GET /tags/:id
  def show
    @tag = Tag.find_by_permalink params[:id]
    @items = current_user.items.find_tagged_with(@tag.name, :order=>'date desc').paginate :page=>params[:page]
  end
  
end