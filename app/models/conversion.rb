class Conversion < ApplicationRecord
  belongs_to :click
  belongs_to :visitor
  belongs_to :campaign
  belongs_to :working_campaign, foreign_key: 'working_campaign_id', class_name: 'Campaign', optional: true
  belongs_to :creative, optional: true

  after_save :send_postback

  scope :waiting, -> { where('status = 0') }
  scope :approved, -> { where('status = 1') }
  scope :declined, -> { where('status = 2') }

  before_save :default_values

  def default_values
    self.working_campaign_id ||= self.campaign_id
  end

  private
  def send_postback
    if self.status == 0
      unless self.ext_id
        case self.campaign.integration
          when 'tlight'
            Postbacks::TLightJob.perform_now(:conversion => self, :offer_id => self.campaign.integration_offer.to_i) #512
          when 'm1shop'
            Postbacks::M1ShopJob.perform_now(:conversion => self, :offer_id => self.campaign.integration_offer.to_i)
        end
      end
    end
  end
end
