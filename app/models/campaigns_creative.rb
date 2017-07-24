class CampaignsCreative < ApplicationRecord
  belongs_to :creative
  belongs_to :campaign
  belongs_to :working_campaign, foreign_key: 'working_campaign_id', class_name: 'Campaign', optional: true


  before_save :default_values
  def default_values
    self.views ||= 0
    self.total_views ||= 0
    self.working_campaign_id ||= self.campaign_id
  end

  def get_total_views(with_parent = false)
    total_views = 0
    histories = CampaignsCreative
    if with_parent
      histories = histories.where(:working_campaign_id => self.working_campaign_id,
                                         :creative_id => self.creative_id)
    else
      histories = histories.where("campaign_id != working_campaign_id AND working_campaign_id = #{self.working_campaign_id} AND
                      creative_id = #{self.creative_id}")
    end
    histories = histories.all
    if histories
      histories.each do |h|
        total_views += h.views
      end
    end
    total_views
  end

  def self.get_total_views(creative, campaign, with_parent = false)
    cc = CampaignsCreative.new
    cc.creative_id = creative.to_i
    cc.working_campaign_id = campaign.to_i
    cc.get_total_views(with_parent)
  end

  def self.get_total_views_by_campaign(campaign, with_parent = false)
    cc = CampaignsCreative.new
    cc.creative_id = creative.to_i
    cc.working_campaign_id = campaign.to_i
    cc.get_total_views(with_parent)
  end

end
