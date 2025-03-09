# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# puts "And some coupon seed data."

# coupons_data = [
#   { name: "Buy One Get One Free", code: "123Free", discount: 100.00, merchant_id: 1 },
#   { name: "Twenty Five Percent Off", code: "Quarter", discount: 25.00, merchant_id: 2 },
#   { name: "Ten Percent", code: "Just10", discount: 10.00, merchant_id: 3 },
# ]

# coupons_data.each do |coupon_data|
#   Coupon.find_or_create_by!(coupon_data)
# end