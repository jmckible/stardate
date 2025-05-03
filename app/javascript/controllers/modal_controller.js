import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // Prevent body scrolling when modal is open
    document.body.style.overflow = 'hidden'
    
    // Set focus to first form element if present
    setTimeout(() => {
      const firstInput = this.element.querySelector('input, select, textarea')
      if (firstInput) firstInput.focus()
    }, 100)
  }

  disconnect() {
    // Restore body scrolling when modal is closed
    document.body.style.overflow = ''
  }

  close(event) {
    if (event.target === this.element) {
      this.element.parentElement.removeAttribute('src')
      this.element.remove()
    }
  }
}
