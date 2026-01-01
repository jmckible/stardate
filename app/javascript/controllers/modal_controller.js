import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  close(event) {
    if (event.target === this.element) {
      this.element.parentElement.removeAttribute('src')
      this.element.remove()
    }
  }
}
