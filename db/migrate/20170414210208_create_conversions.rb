class CreateConversions < ActiveRecord::Migration[5.0]
  def change
    create_table :conversions do |t|
      t.references :click
      t.string :client_name
      t.string :client_phone
      t.string :client_address
      t.string :client_comment
      t.json :extra
      t.integer :status
      t.string :ext_id
      t.string :ext_comment
      t.string :ext_payout
      t.timestamps
    end
  end
end
