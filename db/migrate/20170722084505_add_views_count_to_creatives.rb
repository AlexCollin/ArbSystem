class AddViewsCountToCreatives < ActiveRecord::Migration[5.0]
  def change
    add_column :creatives, :views_count, :integer
  end
end
