class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      # Recipient
      t.references :recipient, null: false, foreign_key: { to_table: :users }, index: true

      # Polymorphic notifiable (Attendance, Transaction, etc.)
      t.references :notifiable, polymorphic: true, null: false, index: true

      # Notification content
      t.string :notification_type, null: false, index: true
      t.text :message, null: false
      t.jsonb :metadata, default: {}

      # Read tracking
      t.boolean :read, default: false, null: false, index: true
      t.datetime :read_at

      t.timestamps
    end

    # Composite index for efficient queries
    add_index :notifications, [:recipient_id, :read, :created_at],
              name: "index_notifications_on_recipient_unread_recent"
  end
end
