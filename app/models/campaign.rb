class Campaign < ApplicationRecord
  has_many :clicks
  has_many :conversions
  has_many :histories, foreign_key: 'parent_id', class_name: 'Campaign'
  has_many :campaigns_creatives
  has_many :creatives, through: :campaigns_creatives, foreign_key: 'creative_id'
  # has_and_belongs_to_many :creatives
  belongs_to :parent, foreign_key: 'parent_id', class_name: 'Campaign', optional: true
  belongs_to :landing, optional: true
  belongs_to :source
  belongs_to :offer

  attr_accessor :history_action

  accepts_nested_attributes_for :campaigns_creatives, allow_destroy: true

  # enum payment_model: [ :cpc, :cpm]

  validates :name, :adv_type, :payment_model, :traffic_cost, :lead_cost,
            :presence => true

  before_save :default_values

  def default_values
    self.views ||= 0
  end

  scope :workings, -> { where('parent_id IS NULL') }
  scope :histories, -> { where('parent_id IS NOT NULL') }

  def to_s
    self.name
  end

  def money(payout)
    def waiting(payout)
      conversions.waiting.count * payout
    end
    def approved(payout)
      conversions.approved.count * payout
    end
    def declined(payout)
      conversions.declined.count * payout
    end
    {:waiting => waiting(payout), :approved => approved(payout), :declined => declined(payout)}
  end

  def get_views_count_from_history(with_self = false)
    total_views = 0
    histories = Campaign.where({:parent_id => self.id, :incremental_views => true}).all
    if histories
      histories.each do |h|
        total_views += h.views
      end
    end
    if with_self
      total_views + self.views
    else
      total_views
    end
  end
end
