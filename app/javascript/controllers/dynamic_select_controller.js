import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zoneSelect", "rateSelect"]
  static values = {
    url: String,
    selected: String,
    kind: String
  }

  connect() {
    console.log(this.selectValue())
    console.log(this.params())
    if (this.selectValue().length > 0) {
      this.fetch()
    }
  }

  change() {
    this.fetch()
  }

  selectValue() {
    return this.zoneSelectTarget.selectedOptions[0].value
  }

  fetch() {
    // fetch(`${this.urlValue}?${this.params()}`)
    fetch(`${this.urlValue}?${this.params()}`, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
  }

  params() {
    let params = new URLSearchParams()
    params.append('id', this.selectValue())
    params.append('kind', this.kindValue)
    params.append('select', this.rateSelectTarget.id)
    params.append('selected', this.selectedValue)
    return params
  }
}