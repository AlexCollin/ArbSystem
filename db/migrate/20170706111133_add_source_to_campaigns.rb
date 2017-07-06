class AddSourceToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :sources
  end
end
