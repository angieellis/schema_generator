class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :categories_items
      t.timestamps null: false
    end
  end
end
