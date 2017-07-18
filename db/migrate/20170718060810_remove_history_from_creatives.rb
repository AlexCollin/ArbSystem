class RemoveHistoryFromCreatives < ActiveRecord::Migration[5.0]
  def change
    remove_reference :campaigns_creatives, :history
  end
end
