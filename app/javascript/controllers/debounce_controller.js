import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form","input", "icon" ]

  search() {
    this.inputTarget.value === ''
      ? this.iconTarget.classList.remove("hidden")
      : this.iconTarget.classList.add("hidden")

    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 250)
    
  }
}