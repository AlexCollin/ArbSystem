class AddSourceToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :source
  end
end
