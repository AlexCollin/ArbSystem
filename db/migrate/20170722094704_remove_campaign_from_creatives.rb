class RemoveCampaignFromCreatives < ActiveRecord::Migration[5.0]
  def change
    remove_column :creatives, :history_id
    remove_column :creatives, :campaign_id
  end
end
