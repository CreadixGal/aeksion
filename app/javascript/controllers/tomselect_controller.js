import TomSelect from "tom-select"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['product', 'zone', 'mainselect', 'secondaryselect', 'variant']

  connect() {
    this.tomSelectInstances = new Map()
    this.secondaryselectTargets.forEach((target) => {
      this.initializeVariantSelect(target)
    })
  }

initialize() {
  console.log('current zone' + this.currentZoneId)
  document.addEventListener("nested-form:added", (event) => {
    if (event.detail && event.detail.variantSelect) {
      // Elimina esta línea:
      // this.initializeVariantSelect(event.detail.variantSelect)

      if (this.currentZoneId) {
        this.loadVariantsForSelect(event.detail.variantSelect, this.currentZoneId)
      }
    }
  })
}

  nestedProducts() {
    new TomSelect(this.productTarget, {
      plugins: {
        remove_button:{
          title:'Remove this item',
        }
      },
      placeholder: "Añadir",
      hideSelected: true,
      maxItems: 1,
      onDelete: function(values) {
        return confirm(values.length > 1 ? 'Seguro que quiere quitar ' + values.length + ' items?' : 'Seguro que quieres quitar el producto?')
      }
    })
  }

  initializeVariantSelect(target) {
    let select
    if (this.tomSelectInstances.has(target)) {
      select = this.tomSelectInstances.get(target)
    } else {
      select = new TomSelect(target, {
        valueField: "value",
        labelField: "text",
        placeholder: "Añadir",
        hideSelected: true,
        maxItems: 1,
        plugins: {
          remove_button: {
            title: "Remove this item",
          },
        },
      })
      this.tomSelectInstances.set(target, select)
    }
  }
  

  nestedZones() {
    new TomSelect(this.zoneTarget, {
      plugins: {
        remove_button:{
          title:'Remove this item',
        }
      },
      placeholder: "Añadir",
      hideSelected: true,
      maxItems: 1,
      onDelete: function(values) {
        return confirm(values.length > 1 ? 'Seguro que quiere quitar ' + values.length + ' items?' : 'Seguro que quieres quitar la zona?')
      }
    })
  }

  loadVariants(event) {
    console.log(this.mainselectTarget)
    console.log(event.target.value)

    this.currentZoneId = event.target.value
    if (!this.currentZoneId) {
      return
    }
  
    this.secondaryselectTargets.forEach((target) => {
      this.loadVariantsForSelect(target, this.currentZoneId)
    })
  }

  loadVariantsForSelect(target, zoneId) {
    fetch(`/variants?zone_id=${zoneId}`, {
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
      },
    })
      .then((response) => response.json())
      .then((variants) => {
        const options = variants.map((variant) => ({
          value: variant.id,
          text: `${variant.code} -> ${variant.price}`,
        }))
  
        let select
        if (this.tomSelectInstances.has(target)) {
          select = this.tomSelectInstances.get(target)
        } else {
          select = new TomSelect(target, {
            valueField: "value",
            labelField: "text",
            placeholder: "Añadir",
            hideSelected: true,
            maxItems: 1,
            plugins: {
              remove_button: {
                title: "Remove this item",
              },
            },
          })
          this.tomSelectInstances.set(target, select)
        }
  
        select.clear()
        select.addOption(options)
        select.refreshItems()
      })
  }
}
