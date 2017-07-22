class RemoveCampaignsCreatives < ActiveRecord::Migration[5.0]
  def change
    drop_table :campaigns_creatives
  end
end
