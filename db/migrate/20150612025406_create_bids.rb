class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :item
      t.references :user
      t.float :amount

      t.timestamps null: false
    end
    # add_index :bids, [:item_id, :bidder_id]
  end
end
