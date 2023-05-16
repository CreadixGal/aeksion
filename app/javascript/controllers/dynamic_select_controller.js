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
    this.element.addEventListener("nested-form:added", this.handleFormAdded.bind(this))
    // document.addEventListener("nested-form:added", this.handleFormAdded.bind(this))
  }

  disconnect() {
    document.removeEventListener("nested-form:added", this.handleFormAdded.bind(this))
  }

  handleFormAdded(event) {
    const { variantSelect, products } = event.detail
    const previousSelectedValue = products
      .map((productSelect) => productSelect.value)
      .find((value) => value !== "")
    variantSelect.innerHTML = products[0]
    variantSelect.value = previousSelectedValue
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

  getCurrentProducts() {
    console.log(this.fetch())
    return this.fetch()
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
    this.nestedFormTargets.forEach((nestedForm) => {
      console.log(nestedForm)
      nestedForm.classList.add("border", "border-blue-500", "p-4", "rounded-md")
      const productSelect = nestedForm.querySelector('select[name*="variant_id"]')
      if (productSelect) {
        const previousSelectedValue = productSelect.value
        productSelect.innerHTML = products
        productSelect.value = previousSelectedValue
      }
    });
  }
}
