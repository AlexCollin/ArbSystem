class Campaign < ApplicationRecord
  has_many :histories, foreign_key: 'parent_id', class_name: 'Campaign'
  has_one :parent, foreign_key: 'parent_id', class_name: 'Campaign'
  belongs_to :source
  belongs_to :offer

  # enum payment_model: [ :cpc, :cpm]

  validates :name, :adv_type, :payment_model, :traffic_cost, :lead_cost,
            :presence => true

  before_save :default_values
  def default_values
    self.views_count ||= 0
  end

  def to_s
    self.name
  end

  def self.get_views_count_from_history(id)
    total_views = 0
    histories = Campaign.where({:parent_id => id, :incremental_views => true}).all
    if histories
      histories.each do |h|
        total_views += h.views_count
      end
    end
    total_views
  end
end
