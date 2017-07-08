class CreateCategoriesOffers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :categories, :offers do |t|
      t.index :offer_id
      t.index :category_id
    end
  end
end
