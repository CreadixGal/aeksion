import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  hideModal() {
    this.element.parentElement.removeAttribute("src") // it might be nice to also remove the modal SRC
    this.element.remove()
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.hideModal()
    }
  }

  closeWithKeyboard(event ) {
    if (event.code == "Escape") {
      this.hideModal()
    }
  }
  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}