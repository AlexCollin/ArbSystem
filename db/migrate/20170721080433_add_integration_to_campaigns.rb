class AddIntegrationToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :integration, :string
    add_column :campaigns, :integration_offer, :string
  end
end
