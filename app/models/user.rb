class User < ActiveRecord::Base
  include BCrypt
  has_many :purchases, class_name: :Item, foreign_key: :buyer_id
  has_many :sales, class_name: :Item, foreign_key: :seller_id
  has_many :bids, class_name: :Bid, foreign_key: :bidder_id
  #has_many :bid_on_items, through: :bids, source: :item

  validates :username, uniqueness: true, presence: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    errors.add(:password, "can't be blank") if new_password == nil
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
