class TagsController < ApplicationController

  # GET /tags
  def index
    @tags = Current.household.tags.visible_by(Current.user).page params[:page]
  end

  # GET /tags/:id
  def show
    @tag = Tag.find_by!(permalink: params[:id])
    @transactions = Current.household.transactions.tagged_with(@tag).visible_by(Current.user).order(date: :desc).page(params[:page])
  end

end
