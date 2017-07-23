class AddWorkingCampaignToCampaignsCreatives < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns_creatives, :working_campaign
  end
end
