import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time", "date"]

  connect() {
    this.updateClock()
    this.timer = setInterval(() => {
      this.updateClock()
    }, 1000)
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  updateClock() {
    const now = new Date()

    // Format time (12-hour format with AM/PM)
    const hours = now.getHours()
    const minutes = now.getMinutes()
    const seconds = now.getSeconds()
    const ampm = hours >= 12 ? 'PM' : 'AM'
    const displayHours = hours % 12 || 12

    const timeString = `${String(displayHours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')} ${ampm}`

    // Format date
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
    const dateString = now.toLocaleDateString('en-US', options)

    this.timeTarget.textContent = timeString
    this.dateTarget.textContent = dateString
  }
}
