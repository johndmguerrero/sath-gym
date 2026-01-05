import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Notification channel connected");
  },

  disconnected() {
    console.log("Notification channel disconnected");
  },

  received(data) {
    console.log("Notification received:", data);

    // Handle different message types
    switch(data.type) {
      case "notification":
        // Insert new notification HTML
        if (data.html) {
          this.insertNotification(data.html);
        }

        // Update badge count
        if (data.count !== undefined) {
          this.updateBadgeCount(data.count);
        }
        break;

      case "count_update":
        // Just update the count
        if (data.count !== undefined) {
          this.updateBadgeCount(data.count);
        }
        break;

      default:
        console.warn("Unknown notification type:", data.type);
    }
  },

  insertNotification(html) {
    const list = document.getElementById('notification-list');
    const emptyState = list?.querySelector('.notification__empty');

    if (!list) return;

    // Remove empty state if present
    if (emptyState) {
      emptyState.remove();
    }

    // Prepend new notification
    list.insertAdjacentHTML('afterbegin', html);
  },

  updateBadgeCount(count) {
    const badge = document.querySelector('[data-notification-target="badge"]');
    const markAllButton = document.querySelector('[data-notification-target="markAllButton"]');

    if (badge) {
      badge.textContent = count;
      badge.style.display = count === 0 ? 'none' : '';
    }

    if (markAllButton) {
      markAllButton.style.display = count === 0 ? 'none' : '';
    }
  }
});
