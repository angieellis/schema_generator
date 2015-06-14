class CreateCategoriesItems < ActiveRecord::Migration
  def change
    create_table :categories_items do |t|
      t.integer :category_id, :item_id
      t.timestamps null: false
    end
    add_index :categories_items, [:category_id, :item_id]
  end
end
