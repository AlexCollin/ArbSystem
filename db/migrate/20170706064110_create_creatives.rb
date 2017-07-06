class CreateCreatives < ActiveRecord::Migration[5.0]
  def change
    create_table :creatives do |t|
      t.integer :views_count
      t.string :title
      t.string :text
      t.string :image
      t.string :descr
      t.string :title2
      t.string :text2
      t.string :image2
      t.string :descr2
      t.string :title3
      t.string :text3
      t.string :image3
      t.string :descr3
      t.string :title4
      t.string :text4
      t.string :image4
      t.string :descr4
      t.string :title5
      t.string :text5
      t.string :image5
      t.string :descr5
      t.string :title6
      t.string :text6
      t.string :image6
      t.string :descr6
      t.string :title7
      t.string :text7
      t.string :image7
      t.string :descr7
      t.string :title8
      t.string :text8
      t.string :image8
      t.string :descr8
      t.string :title9
      t.string :text9
      t.string :image9
      t.string :descr9
      t.timestamps
    end
  end
end
