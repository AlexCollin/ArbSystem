class AddVisitorToConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :conversions, :visitor
  end
end
