class TagsController < ApplicationController
  
  # GET /tags
  def index
    @tags = @user.items.tag_counts order: 'count desc'
  end
  
  # GET /tags/:id
  def show
    @tag = ActsAsTaggableOn::Tag.find params[:id]
    @period = Date.new(2007,1,1)..Time.now.to_date
    @items = @user.items.tagged_with(@tag.name, :order=>'date desc').page(params[:page])
    @items_count = @user.items.tagged_with(@tag.name).size
    @items_sum = @user.items.tagged_with(@tag.name).sum &:value
  end
  
end