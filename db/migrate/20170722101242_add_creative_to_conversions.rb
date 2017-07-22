class AddCreativeToConversions < ActiveRecord::Migration[5.0]
  def change
    add_reference :conversions, :creative
  end
end
