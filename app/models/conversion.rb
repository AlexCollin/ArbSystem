class Conversion < ApplicationRecord
  belongs_to :click
  belongs_to :visitor
  belongs_to :campaign

  after_save :send_postback

  scope :waiting, -> { where('status = 0') }
  scope :approved, -> { where('status = 1') }
  scope :declined, -> { where('status = 2') }

  private
  def send_postback
    if self.status == 0
      unless self.ext_id
        if self.campaign.integration == 'tlight'
          Postbacks::TLightJob.perform_now(:conversion => self, :offer_id => self.campaign.integration_offer.to_i) #512
        end
      end
    end
  end
end
