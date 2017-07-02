class AddOfferToClicks < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :offer
  end
end
