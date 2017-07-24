class AddCalculateViewsOnCreatives < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :calculate_views_on_creatives, :boolean, default: true
  end
end
