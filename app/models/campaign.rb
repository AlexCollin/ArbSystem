class Campaign < ApplicationRecord
  has_many :clicks
  has_many :history_clicks, foreign_key: 'history_id', class_name: 'Click'
  has_many :conversions
  has_many :histories, foreign_key: 'parent_id', class_name: 'Campaign'
  has_and_belongs_to_many :creatives
  has_one :parent, foreign_key: 'parent_id', class_name: 'Campaign'
  belongs_to :landing
  belongs_to :source
  belongs_to :offer

  attr_accessor :history_action

  # enum payment_model: [ :cpc, :cpm]

  validates :name, :adv_type, :payment_model, :traffic_cost, :lead_cost,
            :presence => true

  before_save :default_values

  def default_values
    self.views_count ||= 0
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

  def make_history(views_count, creatives)
    history = self.dup
    history.parent_id = self.id
    history.views_count = views_count
    history.creatives << creatives
    if history.save
      Click.where(history_id: nil, campaign_id: self.id)
          .update_all(history_id: history.id)
      Conversion.where(history_id: nil, campaign_id: self.id)
          .update_all(history_id: history.id)
      history
    end

  end

  def get_views_count_from_history(with_self=false)
    total_views = 0
    histories = Campaign.where({:parent_id => self.id, :incremental_views => true}).all
    if histories
      histories.each do |h|
        total_views += h.views_count
      end
    end
    if with_self
      total_views + self.views_count
    else
      total_views
    end
  end
end
