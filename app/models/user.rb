# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  customer_number        :string
#  date_of_birth          :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  face_scan              :boolean          default(FALSE)
#  first_name             :string
#  gender                 :integer          default("male")
#  height                 :integer
#  last_name              :string
#  nickname               :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  status                 :integer          default("draft"), not null
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
  enum :status, { draft: 0, active: 1, inactive: 2 }
  enum :gender, { male: 0, female: 1 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :subscription
  has_one :subscription_product, through: :subscription

  has_one :user_address

  has_many :attendances
  has_many :social_media_posts
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  after_initialize :build_default_subscription, if: :new_record?

  before_validation :set_default_required_values, on: :create

  accepts_nested_attributes_for :subscription

  accepts_nested_attributes_for :user_address

  delegate :full_address, to: :user_address, allow_nil: true

  # Validations for member creation
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :gender, presence: true
  validates :date_of_birth, presence: true

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

  # Notification helpers
  def unread_notifications_count
    notifications.unread.count
  end

  def subscription_status_badge
    return "No Subscription" unless subscription

    if subscription.active? && subscription.expires_at > Time.current
      "Active"
    elsif subscription.active? && subscription.expires_at <= Time.current
      "Expired"
    else
      "Inactive"
    end
  end

  private

  def build_default_subscription
    build_subscription unless subscription
  end

  def set_default_required_values
    self.role ||= ROLE_MEMBER
    self.password = "Testing123"
    self.password_confirmation = "Testing123"
  end

  def generate_customer_number
    loop do
      self.customer_number = self.class.generate_unique_customer_number
      break unless self.class.exists?(customer_number: customer_number)
    end
  end

  def self.generate_unique_customer_number
    alphanumeric = ("0".."9").to_a + ("a".."z").to_a
    random_code = 6.times.map { alphanumeric.sample }.join
    "cust-#{random_code}"
  end
end
