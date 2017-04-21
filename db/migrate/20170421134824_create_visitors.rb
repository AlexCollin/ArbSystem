class CreateVisitors < ActiveRecord::Migration[5.0]
  def change
    create_table :visitors do |t|
      t.inet :ip
      t.string :ua
      t.string :ident
      t.timestamps
    end
  end
end
