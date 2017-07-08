class AddCampaignToClicksAndConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :campaign
    add_reference :conversions, :campaign
  end
end
