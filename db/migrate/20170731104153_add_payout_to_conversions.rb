class AddPayoutToConversions < ActiveRecord::Migration[5.0]
  def change
    add_column :conversions, :payout, :float
  end
end
