class DeleteOfferFromClicksAndConversions < ActiveRecord::Migration[5.0]
  def change
    remove_column :clicks, :offer_id
    remove_column :conversions, :offer_id
  end
end
