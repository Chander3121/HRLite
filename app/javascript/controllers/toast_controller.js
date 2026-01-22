import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number, url: String }

  connect() {
    const audio = document.getElementById("notification-sound")
    if (audio) {
      audio.currentTime = 0
      audio.play().catch(() => {})
    }

    this.timeout = setTimeout(() => {
      this.element.remove()
    }, this.timeoutValue || 4000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  open() {
    if (this.urlValue) {
      window.location.href = this.urlValue
    }
  }
}
