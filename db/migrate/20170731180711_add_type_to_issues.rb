class AddTypeToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :type, :string
  end
end
