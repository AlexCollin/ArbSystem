class CreateClicks < ActiveRecord::Migration[5.0]
  def change
    create_table :clicks do |t|
      t.inet :ip
      t.string :ua
      t.string :ident
      t.text :referer
      t.integer :cpc
      t.integer :amount
      t.string :s1
      t.string :s2
      t.string :s3
      t.string :s4
      t.string :s5
      t.string :s6
      t.string :s7
      t.string :s8
      t.string :s9
      t.timestamps
    end
    add_index :clicks, :ident
  end
end
