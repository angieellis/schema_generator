class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.string :payment_type, :account_number
      t.text :billing_address
    end
  end
end
