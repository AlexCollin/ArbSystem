class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :description
      t.text :data
      t.timestamps
    end
  end
end
