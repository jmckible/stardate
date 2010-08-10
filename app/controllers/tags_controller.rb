class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = current_user.items.tag_counts :order=>'count desc'
  end
  
  # GET /tags/:id
  def show
    @tag = Tag.find_by_permalink params[:id]
    
    respond_to do |format|
      format.html do
        @items = current_user.items.find_tagged_with(@tag.name, :order=>'date desc').paginate :page=>params[:page]
        @items_count = current_user.items.find_tagged_with(@tag.name).size
        @items_sum = current_user.items.find_tagged_with(@tag.name).sum &:value
      end
      format.xml { @period = Date.new(2007,1,1)..Time.now.to_date }
    end
  end
  
end