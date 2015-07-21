class TagsController < ApplicationController

  # GET /tags
  def index
    @tags = @household.tags.visible_by(@user).page params[:page]
  end

  # GET /tags/:id
  def show
    @tag = Tag.find_by!(permalink: params[:id])
    @transactions = @household.transactions.tagged_with(@tag).visible_by(@user).order(date: :desc).page(params[:page])
  end

end
