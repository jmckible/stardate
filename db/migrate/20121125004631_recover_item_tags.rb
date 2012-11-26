class RecoverItemTags < ActiveRecord::Migration
  def up
    Tagging.update_all "taggable_type = 'Transaction'", "taggable_type = 'Item'"
  end

  def down
  end
end
