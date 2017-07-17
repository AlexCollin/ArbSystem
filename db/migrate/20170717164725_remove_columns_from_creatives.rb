class RemoveColumnsFromCreatives < ActiveRecord::Migration[5.0]
  def up
    remove_column :creatives, :title
    remove_column :creatives, :title2
    remove_column :creatives, :title3
    remove_column :creatives, :title4
    remove_column :creatives, :title5
    remove_column :creatives, :title6
    remove_column :creatives, :title7
    remove_column :creatives, :title8
    remove_column :creatives, :title9

    remove_column :creatives, :text
    remove_column :creatives, :text2
    remove_column :creatives, :text3
    remove_column :creatives, :text4
    remove_column :creatives, :text5
    remove_column :creatives, :text6
    remove_column :creatives, :text7
    remove_column :creatives, :text8
    remove_column :creatives, :text9

    remove_column :creatives, :image
    remove_column :creatives, :image2
    remove_column :creatives, :image3
    remove_column :creatives, :image4
    remove_column :creatives, :image5
    remove_column :creatives, :image6
    remove_column :creatives, :image7
    remove_column :creatives, :image8
    remove_column :creatives, :image9

    remove_column :creatives, :descr
    remove_column :creatives, :descr2
    remove_column :creatives, :descr3
    remove_column :creatives, :descr4
    remove_column :creatives, :descr5
    remove_column :creatives, :descr6
    remove_column :creatives, :descr7
    remove_column :creatives, :descr8
    remove_column :creatives, :descr9
  end

  def down
    add_column :creatives, :title, :string
    add_column :creatives, :title2, :string
    add_column :creatives, :title3, :string
    add_column :creatives, :title4, :string
    add_column :creatives, :title5, :string
    add_column :creatives, :title6, :string
    add_column :creatives, :title7, :string
    add_column :creatives, :title8, :string
    add_column :creatives, :title9, :string

    add_column :creatives, :text, :string
    add_column :creatives, :text2, :string
    add_column :creatives, :text3, :string
    add_column :creatives, :text4, :string
    add_column :creatives, :text5, :string
    add_column :creatives, :text6, :string
    add_column :creatives, :text7, :string
    add_column :creatives, :text8, :string
    add_column :creatives, :text9, :string

    add_column :creatives, :image, :string
    add_column :creatives, :image2, :string
    add_column :creatives, :image3, :string
    add_column :creatives, :image4, :string
    add_column :creatives, :image5, :string
    add_column :creatives, :image6, :string
    add_column :creatives, :image7, :string
    add_column :creatives, :image8, :string
    add_column :creatives, :image9, :string

    add_column :creatives, :descr, :string
    add_column :creatives, :descr2, :string
    add_column :creatives, :descr3, :string
    add_column :creatives, :descr4, :string
    add_column :creatives, :descr5, :string
    add_column :creatives, :descr6, :string
    add_column :creatives, :descr7, :string
    add_column :creatives, :descr8, :string
    add_column :creatives, :descr9, :string
  end
end
