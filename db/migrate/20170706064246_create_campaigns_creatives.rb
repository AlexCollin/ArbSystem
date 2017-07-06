class CreateCampaignsCreatives < ActiveRecord::Migration[5.0]
  def change
    create_join_table :campaigns, :creatives do |t|
      t.index :campaign_id
      t.index :creative_id
    end
  end
end
