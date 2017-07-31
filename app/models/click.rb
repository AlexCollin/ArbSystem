class Click < ApplicationRecord
  has_many :conversions
  belongs_to :visitor
  belongs_to :campaign
  belongs_to :working_campaign, foreign_key: 'working_campaign_id', class_name: 'Campaign', optional: true
  belongs_to :creative, optional: true

  validates :campaign_id, :presence => true

  before_save :default_values

  def default_values
    self.working_campaign_id ||= self.campaign_id
  end

  def is_working_campaign
    self.working_campaign_id == self.campaign_id
  end

  def campaign_creative
    CampaignsCreative.where(:creative_id => self.creative_id, :campaign_id => self.campaign_id).first
  end
end
