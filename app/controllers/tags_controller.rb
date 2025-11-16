class TagsController < ApplicationController

  # GET /tags
  def index
    @tags = Current.household.tags.visible_by(Current.user).page params[:page]

    # Precompute transaction counts and sums for all tags to avoid N queries
    tag_ids = @tags.map(&:id)
    @tag_stats = Current.household.transactions.visible_by(Current.user)
      .joins(:taggings)
      .where(taggings: { tag_id: tag_ids })
      .group('taggings.tag_id')
      .select('taggings.tag_id, COUNT(*) as transaction_count, SUM(amount) as total_amount')
      .index_by(&:tag_id)
  end

  # GET /tags/:id
  def show
    @tag = Tag.find_by!(permalink: params[:id])
    @transactions = Current.household.transactions.tagged_with(@tag).visible_by(Current.user)
      .includes(:vendor, :tags, :debit, :credit, :user)
      .order(date: :desc)
      .page(params[:page])
  end

end
