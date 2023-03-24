import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["add_item", "template"]

  add_association(event) {
    event.preventDefault()  
    var content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf())
    this.add_itemTarget.insertAdjacentHTML('beforebegin', content)

    const newSelect = this.element.querySelector(
      "#select-variant:not([data-tomselect-initialized])"
    );
    if (newSelect) {
      console.log("newSelect", newSelect)
      newSelect.setAttribute("data-tomselect-initialized", "true");
      const customEvent = new CustomEvent("nested-form:added", {
        detail: { variantSelect: newSelect },
      });
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