class AddExtIdToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :ext_id, :string
  end
end
