class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :categories_items
      t.integer :seller_id, :buyer_id
      t.string :name
      t.text :description
      t.float :starting_price, default: 0.0
      t.float :price, default: 0.0
      t.datetime :start_date, :end_date
      t.boolean :sold, default: false

      t.timestamps null: false
    end
    add_index :items, [:seller_id, :buyer_id]
  end
end
