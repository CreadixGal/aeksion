import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['parent', 'child']
  connect() {
    this.childTargets.map(x => x.checked = false)
    this.parentTarget.checked = false
  }

  checkAll() {
    const parent = this.parentTarget
    const childs = this.childTargets
    childs.map(x => x.checked = parent.checked ) 
  }

  checkParent() {
    const parent = this.parentTarget
    const deselect = this.childTargets.map(x => x.checked).includes(false)
    parent.checked = deselect ? false : true
  }
}
