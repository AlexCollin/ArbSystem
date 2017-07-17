ActiveAdmin.register CampaignsCreative do
  index do
    selectable_column
    column :campaign_id
    column :creative_id
    column :history_id
  end
end

