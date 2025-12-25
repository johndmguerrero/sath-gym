import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number
  }

  toggleStatus(event) {
    const checkbox = event.target
    const isActive = checkbox.checked

    fetch(`/products/${this.idValue}/toggle_status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        status: isActive ? "active" : "inactive"
      })
    })
    .then(response => {
      if (!response.ok) {
        checkbox.checked = !isActive
        console.error("Failed to update product status")
      }
    })
    .catch(error => {
      checkbox.checked = !isActive
      console.error("Error:", error)
    })
  }
}
