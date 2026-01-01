import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.mousedownOnBackground = false
  }

  handleMouseDown(event) {
    // Record if mousedown occurred on the background (not on modal content)
    this.mousedownOnBackground = event.target === this.element
  }

  close(event) {
    // Only close if both mousedown AND click occurred on the background
    if (event.target === this.element && this.mousedownOnBackground) {
      this.element.parentElement.removeAttribute('src')
      this.element.remove()
    }
    // Reset for next interaction
    this.mousedownOnBackground = false
  }
}
