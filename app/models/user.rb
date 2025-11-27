# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  age                    :integer
#  customer_number        :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  height                 :integer
#  last_name              :string
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  status                 :integer          default("active"), not null
#  weight                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  enum :status, { active: 0, deactivate: 1, walkins: 2}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :subscription
  has_one :subscription_product, through: :subscription

  before_create :generate_customer_number, if: -> { customer_number.blank? }

  ROLE_ADMIN = "Admin"
  ROLE_MEMBER = "Member"

  scope :members, -> { where(:role => ROLE_MEMBER)}

  def self.ransackable_attributes(auth_object = nil)
    %w[ nickname first_name last_name status email]
  end

  def self.ransackable_associations(auth_object = nil)
    ["subscription", "subscription_product"]
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def admin?
    role.eql? ROLE_ADMIN
  end

  def member?
    !admin?
  end

  private

  def generate_customer_number
    loop do
      self.customer_number = self.class.generate_unique_customer_number
      break unless self.class.exists?(customer_number: customer_number)
    end
  end

  def self.generate_unique_customer_number
    alphanumeric = ("0".."9").to_a + ("a".."z").to_a
    random_code = 6.times.map { alphanumeric.sample }.join
    "CUST-#{random_code}"
  end
end
