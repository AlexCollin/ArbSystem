class AddCompanyToCreatives < ActiveRecord::Migration[5.0]
  def change
    add_reference :creatives, :campaign
    add_reference :creatives, :history
  end
end
