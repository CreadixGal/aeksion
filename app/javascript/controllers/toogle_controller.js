import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "aside", "button" ]

  hide(e) {
    e.preventDefault()
    const aside = this.asideTarget
    const button = this.buttonTarget
    aside.classList.contains('hidden') ? aside.classList.remove('hidden') : aside.classList.add('hidden')
    button.classList.contains('hidden') ? button.classList.remove('hidden') : button.classList.add('hidden')
  }
}
