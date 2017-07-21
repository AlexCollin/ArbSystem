class AddLandingToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :landing
  end
end
