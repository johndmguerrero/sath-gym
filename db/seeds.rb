# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "faker"

puts "Seeding member users..."


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
  status = [ :active, :active, :active, :active, :active, :active, :active, :active, :deactivate, :walkins ].sample

  user = User.create!(
    email: email,
    first_name: first_name,
    last_name: last_name,
    nickname: nickname,
    age: age,
    height: height,
    weight: weight,
    role: User::ROLE_MEMBER,
    status: status,
    password: "Testing123",
    password_confirmation: "Testing123"
  )

  puts "Created member: #{user.email} - #{user.fullname} (#{user.status})"
end

puts "\n" + "=" * 30
puts "Seeding complete!"
puts "Total users: #{User.count}"
puts "Admin users: #{User.where(role: User::ROLE_ADMIN).count}"
puts "Member users: #{User.where(role: User::ROLE_MEMBER).count}"
puts "Active: #{User.where(status: :active).count}"
puts "Deactivated: #{User.where(status: :deactivate).count}"
puts "Walk-ins: #{User.where(status: :walkins).count}"
puts "=" * 30
