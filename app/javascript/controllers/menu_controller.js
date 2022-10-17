import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.check_state()
  }

  storage(event) {
    localStorage.setItem("item", event.target.dataset.menuItem)
  }

  check_state() {
    this.itemTargets.forEach((item) => {
      this.change_state(localStorage.getItem('item'), item, "bg-gray-600")
    })
  }

  change_state(stored_value, item, style) {
    let active = stored_value == item.dataset.menuItem
    item.classList.toggle(style, active);
  }
}