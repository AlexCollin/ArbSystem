class RemoveViewsCountFromCreatives2 < ActiveRecord::Migration[5.0]
  def change
    remove_column :creatives, :views_count
  end
end
