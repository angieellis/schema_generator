class Item < ActiveRecord::Base
  has_many :bids, dependent: :destroy
  has_many :categories_items
  has_many :categories, through: :categories_items

  belongs_to :seller, class_name: :User, foreign_key: :seller_id
  belongs_to :buyer, class_name: :User, foreign_key: :buyer_id

  before_create :set_price, :default_prices

  validates :name, presence: true, uniqueness: true

  # def price=(new_price)
  #   return self.price < new_price ? self.price = new_price : self.price
  # end

  def set_price
    self.price = self.starting_price
  end

  def default_prices
    self.starting_price ||= 0.0
    self.price ||= 0.0
  end
end
