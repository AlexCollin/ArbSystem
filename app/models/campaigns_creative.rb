class CampaignsCreative < ApplicationRecord
  belongs_to :campaign
  belongs_to :creative
end
