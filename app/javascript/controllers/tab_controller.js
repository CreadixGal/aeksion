import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["option"]

  connect() {
    this.check_state()
  }

  storage(event) {
    localStorage.setItem("option", event.target.dataset.tabOption)
  }

  check_state() {
    this.optionTargets.forEach((option) => {
      this.change_state(localStorage.getItem('option'), option, "")
    })
  }

  change_state(stored_value, option, style) {
    let active = stored_value == option.dataset.tabOption
    option.classList.toggle(style, active);
  }
}
