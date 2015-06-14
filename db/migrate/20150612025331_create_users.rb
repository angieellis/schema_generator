class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :account
      t.string :username, :password_hash, :first_name, :last_name, :email, :phone

      t.timestamps null: false
    end
  end
end
