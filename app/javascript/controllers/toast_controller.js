import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: Number,
    url: String
  }

  connect() {
    // ✅ enforce stack limit
    this.enforceLimit()

    // ✅ play sound
    const audio = document.getElementById("notification-sound")
    if (audio) {
      audio.currentTime = 0
      audio.play().catch(() => {})
    }

    // ✅ auto-dismiss
    this.startTimer()
  }

  enforceLimit() {
    const container = document.getElementById("toast-container")
    if (!container) return

    const toasts = container.querySelectorAll("[data-controller='toast']")
    if (toasts.length > 3) {
      // remove oldest first (bottom)
      for (let i = 3; i < toasts.length; i++) {
        toasts[i].remove()
      }
    }
  }

  startTimer() {
    this.timeoutId = setTimeout(() => {
      this.element.remove()
    }, this.timeoutValue || 5000)
  }

  stopTimer() {
    if (this.timeoutId) clearTimeout(this.timeoutId)
  }

  disconnect() {
    this.stopTimer()
  }

  open() {
    if (this.urlValue) window.location.href = this.urlValue
  }

  close(event) {
    event.preventDefault()
    event.stopPropagation()
    this.element.remove()
  }

  // ✅ Pause dismiss on hover
  pause() {
    this.stopTimer()
  }

  resume() {
    this.startTimer()
  }
}
