class UpdateCreatives < ActiveRecord::Migration[5.0]
  def change
    add_reference :creatives, :offer
    remove_reference :creatives, :campaign
  end
end
