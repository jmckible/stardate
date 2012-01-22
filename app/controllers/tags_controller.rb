class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = current_user.items.tag_counts :order=>'count desc'
  end
  
  # GET /tags/:id
  def show
    @tag = ActsAsTaggableOn::Tag.find params[:id]
    @period = Date.new(2007,1,1)..Time.now.to_date
    
    respond_to do |format|
      format.html do
        @items = current_user.items.tagged_with(@tag.name, :order=>'date desc').page(params[:page])
        @items_count = current_user.items.tagged_with(@tag.name).size
        @items_sum = current_user.items.tagged_with(@tag.name).sum &:value
      end
      format.xml
    end
  end
  
end