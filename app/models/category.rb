class Category < ApplicationRecord
  has_and_belongs_to_many :offers
  accepts_nested_attributes_for :offers

  validates_uniqueness_of :name, :case_sensitive => false
end
