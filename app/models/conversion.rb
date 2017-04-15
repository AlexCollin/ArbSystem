class Conversion < ApplicationRecord
  belongs_to :click

  after_save :send_postback

  private
  def send_postback
    unless self.ext_id and self.status == 0
      Postbacks::TLightJob.set(queue: :postbacks).perform_later(:conversion => self)
    end
  end
end
