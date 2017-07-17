class AddPaperclipImagesToCreatives < ActiveRecord::Migration[5.0]
  def up
    add_column :creatives, :title, :string
    add_column :creatives, :text, :string
    add_column :creatives, :description, :text
    add_attachment :creatives, :image
  end

  def down
    remove_column :creatives, :title
    remove_column :creatives, :text
    remove_column :creatives, :description
    remove_attachment :creatives, :image
  end
end
