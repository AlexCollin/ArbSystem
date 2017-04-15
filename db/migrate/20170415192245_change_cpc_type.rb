class ChangeCpcType < ActiveRecord::Migration[5.0]
  def change
    change_column :clicks, :cpc, :float
  end
end
