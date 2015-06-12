# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 7.times do
#   u = Faker::Internet.user_name
#   User.create(username: u, password: u, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.cell_phone)
# end

# 8.times do
#   f = Faker::Commerce.department
#   unless Category.all.select(:name).include?(f)
#     Category.create(name: Faker::Commerce.department)
#   end
# end

# 25.times do
#   date = (DateTime.now + Random.rand(-12..12))
#   names = []
#   c, d = Category.all.sample(2)
#   unless c == d
#     u = User.all.sample
#     p = Faker::Commerce.price
#     name = Faker::Commerce.product_name
#     unless names.include?(name)
#       names << name
#       i = Item.create(name: name, description: Faker::Lorem.paragraph, starting_price: p, price: p, start_date: date, end_date: (date + 4.days))
#       i.categories.push(c, d)
#       # c.items << i
#       # d.items << i
#       u.sales << i
#       i.seller = u
#     end
#   end
# end

# User.all.each do |user|
#   4.times do
#     i = Item.all.sample
#     if Bid.where(item_id: i.id, bidder_id: user.id) != nil
#       b = Bid.create(item_id: i.id, bidder_id: user.id, amount: (i.price + 5))
#     end
#     i.price += 5
#     i.save
#     user.bids << b
#     b.bidder = user
#   end
# end
