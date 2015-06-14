class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.references :authors_books
      t.string :name

      t.timestamps null: false
    end
  end
end
