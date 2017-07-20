ActiveAdmin.register CampaignsCreative do
  menu parent: 'Campaigns'

  index do
    selectable_column
    column :campaign do |row|
      link_to "#{(row.campaign.parent_id)?'History -':''}#{row.campaign.name}(#{row.campaign_id})", admin_campaign_path(row.campaign_id)
    end
    column :creative do |row|
      link_to row.creative.title, admin_creative_path(row.creative_id)
    end
    column 'Image' do |row|
      image_tag(row.creative.image.url(:thumb))
    end
  end
end

