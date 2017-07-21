class CreateLandings < ActiveRecord::Migration[5.0]
  def change
    create_table :landings do |t|
      t.string :name
      t.string :url
      t.boolean :is_external, default: false
      t.boolean :is_transit, default: false
      t.timestamps
    end
  end
end
