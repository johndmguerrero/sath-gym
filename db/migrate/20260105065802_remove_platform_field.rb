class RemovePlatformField < ActiveRecord::Migration[8.0]
  def change
    remove_column :social_media_posts, :platform, null: false, default: "facebook"
  end
end
