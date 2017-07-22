class RemoveHistoryFromClicks < ActiveRecord::Migration[5.0]
  def change
    remove_column :clicks, :history_id
  end
end
