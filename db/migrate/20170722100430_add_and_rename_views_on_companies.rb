class AddAndRenameViewsOnCompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :campaigns, :views_count, :views
    add_column :campaigns, :total_views, :integer
  end
end
