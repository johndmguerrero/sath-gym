import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge", "list", "empty", "markAllButton"]

  connect() {
    console.log("Notification controller connected")
  }

  // Mark single notification as read
  async markAsRead(event) {
    const notificationId = event.currentTarget.dataset.notificationId

    try {
      const response = await fetch(`/notifications/${notificationId}/mark_as_read`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      })

      if (response.ok) {
        // Update UI - remove unread styling
        const notificationElement = document.getElementById(`notification_${notificationId}`)
        notificationElement?.classList.remove('notification-item--unread')

        // Hide the "mark as read" button
        event.currentTarget.style.display = 'none'
      }
    } catch (error) {
      console.error('Failed to mark notification as read:', error)
    }
  }

  // Mark all notifications as read
  async markAllAsRead() {
    try {
      const response = await fetch('/notifications/mark_all_as_read', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'text/vnd.turbo-stream.html'
        }
      })

      if (response.ok) {
        // Turbo Stream will handle the UI update
      }
    } catch (error) {
      console.error('Failed to mark all as read:', error)
    }
  }
}
