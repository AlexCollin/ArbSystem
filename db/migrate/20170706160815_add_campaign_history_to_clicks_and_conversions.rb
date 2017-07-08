class AddCampaignHistoryToClicksAndConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :campaign_history
    add_reference :conversions, :campaign_history
  end
end
