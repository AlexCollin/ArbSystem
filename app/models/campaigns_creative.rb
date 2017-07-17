class CampaignsCreative < ApplicationRecord
  belongs_to :campaign
  belongs_to :creative
  belongs_to :history, foreign_key: 'history_id', class_name: 'Campaign'
end
