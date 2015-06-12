class Bid < ActiveRecord::Base
  belongs_to :item
  # belongs_to :bidder, class_name: :User, foreign_key: :bidder_id
  belongs_to :user

  validate :check_for_duplicate_users

  def check_for_duplicate_users
    errors.add(:bidder_id, "Bidder cannot bid on their own item") if self.bidder_id == Item.find_by(id: self.item_id).seller_id
  end

  def check_for_duplicate_bids
    Bid.where(id: self.item_id, bidder_id: self.user_id).length > 1
  end

  def verify_bid_amount
    self.amount > Item.find_by(id: self.item_id).price
  end

  def update_current_item_price
    Item.find_by(id: self.item_id).price = self.amount
  end
end
