class Offer < ApplicationRecord
  has_many :categories_offers, foreign_key: 'offer_id'
  has_many :campaigns
  has_many :creatives
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories, :categories_offers,  allow_destroy: true
end
