# == Schema Information
#
# Table name: social_media_posts
# Database name: primary
#
#  id            :bigint           not null, primary key
#  cached_tokens :integer
#  content       :text             not null
#  input_tokens  :integer
#  metadata      :jsonb
#  output_tokens :integer
#  status        :integer          default("draft"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_social_media_posts_on_created_at  (created_at)
#  index_social_media_posts_on_status      (status)
#  index_social_media_posts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class SocialMediaPost < ApplicationRecord
  belongs_to :user

  enum :status, { draft: 0, published: 1, archived: 2 }

  # Validations
  validates :content, presence: true, length: { minimum: 10, maximum: 5000 }
  validates :status, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  default_scope { recent }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[content status created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  # Instance methods
  def word_count
    content.split.size
  end

  def character_count
    content.length
  end

  def publish!
    update!(status: :published, metadata: metadata.merge(published_at: Time.current))
  end

  def archive!
    update!(status: :archived)
  end
end
