class CreateSocialMediaPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :social_media_posts do |t|
      t.string :platform, null: false, default: 'facebook'
      t.text :content, null: false
      t.integer :status, null: false, default: 0
      t.jsonb :metadata, default: {}
      t.integer :input_tokens
      t.integer :output_tokens
      t.integer :cached_tokens
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :social_media_posts, :status
    add_index :social_media_posts, :platform
    add_index :social_media_posts, :created_at
  end
end
