class Creative < ApplicationRecord
  belongs_to :offer
  has_many :campaigns_creatives, foreign_key: 'creative_id', class_name: 'CampaignsCreative'
  has_and_belongs_to_many :campaigns, foreign_key: 'campaign_id', class_name: 'Campaign'
  #has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :working_campaigns, foreign_key: 'working_campaign_id', class_name: 'Campaign'
  # accepts_nested_attributes_for :campaigns_creatives
  #has_attached_file :image

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_file_name :image, matches: [/png\z/, /jpe?g\z/]
  validates_attachment_presence :image
  # validates_uniqueness_of :image_file_name

  # before_post_process :parse_file_name
  # def parse_file_name
  #   version_match = /_(?\d+)_(?\d+)_(?\d+)\.bin$/.match(image_file_name)
  #   if version_match.present? and version_match[:major] and version_match[:minor] and version_match[:patch]
  #     self.major_version = version_match[:major]
  #     self.minor_version = version_match[:minor]
  #     self.patch_version = version_match[:patch]
  #   end
  # end

end
