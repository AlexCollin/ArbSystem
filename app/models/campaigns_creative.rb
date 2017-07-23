class CampaignsCreative < ApplicationRecord
  has_many :creatives
  has_many :campaigns

  before_save :default_values
  def default_values
    self.views ||= 0
  end
end
