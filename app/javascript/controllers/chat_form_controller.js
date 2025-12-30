import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-form"
export default class extends Controller {
  submit(event) {
    // Allow form submission on Enter key (without Shift)
    if (event.shiftKey) {
      return // Allow new line with Shift+Enter
    }

    event.preventDefault()
    this.element.requestSubmit()
  }
}
