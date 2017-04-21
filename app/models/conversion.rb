class Conversion < ApplicationRecord
  belongs_to :click
  belongs_to :visitor

  after_save :send_postback

  private
  def send_postback
    if self.status == 0
      unless self.ext_id
        Postbacks::TLightJob.perform_now(:conversion => self)
      end
    end
  end
end
