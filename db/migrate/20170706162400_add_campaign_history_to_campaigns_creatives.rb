class AddCampaignHistoryToCampaignsCreatives < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns_creatives, :campaign_history
  end
end
