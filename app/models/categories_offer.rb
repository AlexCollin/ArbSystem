class CategoriesOffer < ApplicationRecord
  belongs_to :offers
  belongs_to :categories
end
