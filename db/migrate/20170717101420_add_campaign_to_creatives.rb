class AddCampaignToCreatives < ActiveRecord::Migration[5.0]
  def change
    add_reference :creatives, :campaign
  end
end
