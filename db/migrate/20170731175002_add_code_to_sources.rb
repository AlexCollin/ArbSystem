class AddCodeToSources < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :code, :string
  end
end
