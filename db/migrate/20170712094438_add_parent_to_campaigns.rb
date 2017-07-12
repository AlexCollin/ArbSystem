class AddParentToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :parent
  end
end
