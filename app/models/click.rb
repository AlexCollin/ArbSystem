class Click < ApplicationRecord
  has_many :conversions
  belongs_to :visitor
  belongs_to :campaign
  belongs_to :working_campaign, foreign_key: 'working_campaign_id', class_name: 'Campaign'
  belongs_to :creative

  validates :campaign_id, :presence => true
end
