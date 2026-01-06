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
  interval_count: 30,
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


30.times do
  gender = [ :male, :female ].sample
  age = rand(18..65)

  height = if gender == :male
    rand(165..195)
  else
    rand(155..180)
  end

  base_weight = height - 100
  weight = base_weight + rand(-15..25)

  # Generate name based on gender
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  nickname = Faker::Name.initials(number: 2)

  # Generate unique email
  email = Faker::Internet.unique.email(name: "#{first_name}.#{last_name}")

  # Random status distribution (80% active, 15% deactivate, 5% walkins)
  status = [ :draft, :draft, :draft, :draft, :draft, :draft, :draft, :active, :active, :inactive ].sample

  user = User.create(
    email: email,
    first_name: first_name,
    last_name: last_name,
    nickname: nickname,
    date_of_birth: DateTime.now - 20.years,
    height: height,
    weight: weight,
    phone_number: Faker::PhoneNumber.phone_number,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
    role: User::ROLE_MEMBER,
    status: status,
    password: "Testing123",
    password_confirmation: "Testing123",
    subscription_attributes: {
      product_plan_id: 2,
      expires_at: DateTime.now + 1.year
    }
  )

  puts "Created member: #{user.email} - #{user.fullname} (#{user.status})"
end