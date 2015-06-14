class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :authors_books
      t.string :title
      t.date :publication_date
      t.timestamps null: false
    end
  end
end
