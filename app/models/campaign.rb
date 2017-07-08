class Campaign < ApplicationRecord
  has_many :campaign_histories
  has_one :source
  has_one :offer
end
