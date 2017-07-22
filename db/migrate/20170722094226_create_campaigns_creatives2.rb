class CreateCampaignsCreatives2 < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns_creatives do |t|
      t.integer :views
      t.integer :total_views
      t.timestamps
    end
    add_reference :campaigns_creatives, :campaign
    add_reference :campaigns_creatives, :creative
  end
end
