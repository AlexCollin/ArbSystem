class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.string :adv_type
      t.boolean :incremental_views, default: true
      t.string :payment_model
      t.float :traffic_cost
      t.float :lead_cost
      t.integer :views_count
      t.timestamps
    end
    add_reference :campaigns, :offer
  end
end
