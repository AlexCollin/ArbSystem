class AddVisitorToClicks < ActiveRecord::Migration[5.0]
  def change
    add_reference :clicks, :visitor
  end
end
