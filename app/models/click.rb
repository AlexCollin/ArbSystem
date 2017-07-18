class Click < ApplicationRecord
  has_many :conversions
  belongs_to :visitor
  belongs_to :campaign
end
