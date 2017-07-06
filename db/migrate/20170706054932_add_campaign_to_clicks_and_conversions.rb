class AddCampaignToClicksAndConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :campaigns
    add_reference :conversions, :campaigns
  end
end
