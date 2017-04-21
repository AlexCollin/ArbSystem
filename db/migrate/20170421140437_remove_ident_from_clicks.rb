class RemoveIdentFromClicks < ActiveRecord::Migration[5.0]
  def change
    remove_column :clicks, :ip
    remove_column :clicks, :ua
    remove_column :clicks, :ident
  end
end
