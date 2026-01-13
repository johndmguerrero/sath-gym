# == Schema Information
#
# Table name: attendances
# Database name: primary
#
#  id         :bigint           not null, primary key
#  remarks    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_attendances_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :attendance do
    
  end
end
