import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["add_item", "template"]

  connect() {
    document.addEventListener("nested-form:added", this.handleFormAdded.bind(this));
  }

  disconnect() {
    document.removeEventListener("nested-form:added", this.handleFormAdded.bind(this));
  }

  handleFormAdded(event) {
    // Actualizar el select de product_id aquí
    // Puedes acceder al select recién agregado mediante event.detail.variantSelect
  }

  add_association(event) {
    event.preventDefault()
    var content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf())
    this.add_itemTarget.insertAdjacentHTML('beforebegin', content)

    const newSelect = this.element.querySelector(
      "#select-variant:not([data-dynamic-select-initialized])"
    );
    if (newSelect) {
      console.log("newSelect", newSelect)
      newSelect.setAttribute("data-dynamic-select-initialized", "true");
      const customEvent = new CustomEvent("nested-form:added", {
        detail: { variantSelect: newSelect },
      });
      console.log('coas añadida')
      document.dispatchEvent(customEvent);
    } else {
      console.log("No new select found");
    }
  }

  remove_association(event) {
    event.preventDefault()
    let item = event.target.closest(".nested-fields")
    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = 'none'
  }
}
