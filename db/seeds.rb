# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "faker"

puts "[SEED] Default Product..."

product = Product.new(
  name: "Sath Gym Membership",
  description: "Defaullt non-promo gym membership"
)

product.plans.build(
  interval_count: 1,
  price: 2000
)

product.plans.build(
  interval: 1,
  interval_count: 1,
  price: 20000
)

product.save

puts "[SEED] Creating default Admin"

User.create(
  first_name: "Admin",
  last_name: "Sath",
  role: "Admin",
  email: "admin@email.com",
  phone_number: Faker::PhoneNumber.phone_number,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
  password: "Testing123",
  password_confirmation: "Testing123",
  subscription_attributes: {
    product_plan_id: 1,
    expires_at: DateTime.now + 10.years
  }
)

puts "[SEED] Members..."
