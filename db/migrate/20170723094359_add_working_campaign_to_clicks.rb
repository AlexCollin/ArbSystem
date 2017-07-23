class AddWorkingCampaignToClicks < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :working_campaign
  end
end
