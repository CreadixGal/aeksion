import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "aside" ]
  hide(e) {
    e.preventDefault()
    const aside = this.asideTarget
    aside.classList.contains('hidden') ? aside.classList.remove('hidden') : aside.classList.add('hidden')
  }
}
