class RenameCampaignHistoryKeys < ActiveRecord::Migration[5.0]
  def change
    rename_column :clicks, :campaign_history_id, :history_id
    rename_column :conversions, :campaign_history_id, :history_id
    rename_column :campaigns_creatives, :campaign_history_id, :history_id
  end
end
