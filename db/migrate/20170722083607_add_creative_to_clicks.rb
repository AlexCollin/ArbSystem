class AddCreativeToClicks < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :creative
  end
end
