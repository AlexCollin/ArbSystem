class AddExtIdToCampaignsCreatives < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns_creatives, :ext_id, :string
  end
end
