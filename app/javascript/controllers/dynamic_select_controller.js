import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zoneSelect", "rateSelect", "nestedForm"]
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
    document.addEventListener("nested-form:added", this.handleFormAdded.bind(this));
  }

  disconnect() {
    document.removeEventListener("nested-form:added", this.handleFormAdded.bind(this));
  }

  handleFormAdded(event) {
    this.updateProductSelects(event.detail.products);
  }

  change() {
    this.fetch()
  }

  selectValue() {
    return this.zoneSelectTarget.selectedOptions[0].value
  }

  fetch() {
    fetch(`${this.urlValue}?${this.params()}`, {
      headers: {
        Accept: "application/json"
      }
    })
    .then(r => r.json())
    .then(data => {
      this.updateRateSelect(data.rates)
      this.updateProductSelects(data.products)
    })
  }

  params() {
    let params = new URLSearchParams()
    params.append('id', this.selectValue())
    params.append('kind', this.kindValue)
    params.append('selected', this.selectedValue)
    return params
  }

  updateRateSelect(rates) {
    this.rateSelectTarget.innerHTML = rates;
  }

  updateProductSelects(products) {
    this.nestedFormTargets.forEach(nestedForm => {
      console.log(nestedForm)
      nestedForm.classList.add('border', 'border-blue-500', 'p-4', 'rounded-md')
      const productSelect = nestedForm.querySelector('select[name*="product_id"]')
      if (productSelect) {
        productSelect.innerHTML = products;
      }
    })
  }
}
