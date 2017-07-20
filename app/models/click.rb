class Click < ApplicationRecord
  has_many :conversions
  belongs_to :visitor
  belongs_to :campaign
  belongs_to :history_campaign ,foreign_key: 'history_id', class_name: 'Campaign', optional: true
  belongs_to :history, foreign_key: 'history_id', class_name: 'Campaign', optional: true
``
  validates :campaign_id, :presence => true
end
