class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :subscription
  has_one :subscription_product, through: :subscription

  ROLE_ADMIN = "Admin"
  ROLE_MEMBER = "Member"

  scope :members, -> { where(:role => ROLE_MEMBER)}

  def fullname
    "#{first_name} #{last_name}"
  end

  def admin?
    role.eql? ROLE_ADMIN
  end

  def member?
    !admin?
  end
end
