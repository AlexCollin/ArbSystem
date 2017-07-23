class AddWorkingCampaignToConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :conversions, :working_campaign
  end
end
