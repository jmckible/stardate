import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // Check if we're on a non-mobile device (desktop)
    if (window.matchMedia('(min-width: 768px)').matches) {
      // Only autofocus on desktop
      setTimeout(() => {
        this.element.focus()
      }, 100) // Short delay to ensure DOM is fully loaded
    }
  }
}